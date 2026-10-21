"""Focused safety checks: isolated home directories, no live app settings or installs."""
import importlib.util
import json
import os
from pathlib import Path
import plistlib
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).with_name('configure.py')
spec = importlib.util.spec_from_file_location('configure', SCRIPT)
config = importlib.util.module_from_spec(spec)
spec.loader.exec_module(config)


class ConfigurationTests(unittest.TestCase):
    def test_dotfiles_preview_backup_idempotence_and_directory_protection(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            original = home / '.zshrc'
            original.write_text('private existing shell settings\n')
            env = dict(os.environ, HOME=str(home))
            command = ['python3', str(SCRIPT), 'dotfiles']
            subprocess.run(command, env=env, check=True, capture_output=True)
            self.assertEqual(original.read_text(), 'private existing shell settings\n')
            self.assertFalse((home / '.config-backups').exists())
            subprocess.run(command + ['--apply'], env=env, check=True, capture_output=True)
            self.assertTrue(original.is_symlink())
            saved = list((home / '.config-backups').glob('*/.zshrc'))
            self.assertEqual(len(saved), 1)
            self.assertEqual(saved[0].read_text(), 'private existing shell settings\n')
            self.assertEqual(saved[0].parent.stat().st_mode & 0o777, 0o700)
            subprocess.run(command + ['--apply'], env=env, check=True, capture_output=True)
            self.assertEqual(list((home / '.config-backups').glob('*/.zshrc')), saved)
            original.unlink()
            original.mkdir()
            failure = subprocess.run(command + ['--apply'], env=env, capture_output=True)
            self.assertNotEqual(failure.returncode, 0)
            self.assertTrue(original.is_dir())

    def test_json_preserves_unmanaged_fields_and_backs_up_before_merge(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            incoming = home / 'source.json'
            target = home / 'settings.json'
            old = {'settings': {'private_option': 'keep', 'bindings': {'other': 42}, 'selected_model': 'old'}, 'other_store': 5}
            target.write_text(json.dumps(old))
            incoming.write_text(json.dumps({'bindings': {'transcribe': 'fn'}, 'selected_model': 'turbo'}))
            with patch.object(config, 'ROOT', home), patch.object(config, 'HOME', home), patch.object(config, 'BACKUP', home / 'backup'):
                config.json_config(incoming, target, False, wrapper='settings')
                self.assertEqual(json.loads(target.read_text()), old)
                config.json_config(incoming, target, True, wrapper='settings')
                result = json.loads(target.read_text())
                self.assertEqual(result['settings']['bindings'], {'other': 42, 'transcribe': 'fn'})
                self.assertEqual(result['settings']['private_option'], 'keep')
                self.assertEqual(result['settings']['selected_model'], 'turbo')
                self.assertEqual(result['other_store'], 5)
                self.assertEqual(json.loads((home / 'backup/settings.json').read_text()), old)

    def test_preferences_merge_retains_unrelated_hotkeys(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            prefs = root / 'config/macos'
            prefs.mkdir(parents=True)
            before = {'unrelated': 'keep', 'AppleSymbolicHotKeys': {'1': {'enabled': True}, '60': {'enabled': True}}}
            (prefs / 'test.domain.plist').write_bytes(plistlib.dumps({'AppleSymbolicHotKeys': {'60': {'enabled': False}}}))
            imported = []

            def fake_run(command, **kwargs):
                if command[1] == 'export':
                    return subprocess.CompletedProcess(command, 0, stdout=plistlib.dumps(before))
                imported.append(plistlib.loads(Path(command[-1]).read_bytes()))
                return subprocess.CompletedProcess(command, 0)

            with patch.object(config, 'ROOT', root), patch.object(config, 'HOME', root), patch.object(config, 'BACKUP', root / 'backup'), patch.object(config.subprocess, 'run', side_effect=fake_run):
                config.preferences('macos', True)
            self.assertEqual(imported[0]['unrelated'], 'keep')
            self.assertTrue(imported[0]['AppleSymbolicHotKeys']['1']['enabled'])
            self.assertFalse(imported[0]['AppleSymbolicHotKeys']['60']['enabled'])
            self.assertEqual(plistlib.loads((root / 'backup/preferences/test.domain.plist').read_bytes()), before)

    def test_running_app_blocks_restore(self):
        with patch.object(config.subprocess, 'check_output', return_value='/Applications/T3 Code (Beta).app/Contents/MacOS/T3 Code (Beta)\n'):
            with self.assertRaises(SystemExit):
                config.ensure_closed('t3')

    def test_invalid_existing_json_is_not_replaced(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, target = root / 'incoming', root / 'existing'
            source.write_text('{}')
            target.write_text('{invalid')
            with self.assertRaises(json.JSONDecodeError):
                config.json_config(source, target, True)
            self.assertEqual(target.read_text(), '{invalid')


if __name__ == '__main__':
    unittest.main()
