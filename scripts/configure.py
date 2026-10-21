#!/usr/bin/env python3
"""Apply allowlisted public configuration; preview by default, backup before writes."""
import argparse
import copy
import datetime
import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent.parent
HOME = Path.home()
BACKUP = HOME / '.config-backups' / (datetime.datetime.now().strftime('%Y%m%d-%H%M%S') + '-' + str(os.getpid()))


def merge(existing, incoming):
    result = copy.deepcopy(existing)
    for key, value in incoming.items():
        if isinstance(value, dict) and isinstance(result.get(key), dict):
            result[key] = merge(result[key], value)
        else:
            result[key] = copy.deepcopy(value)
    return result


def backup(path):
    if path.exists() or path.is_symlink():
        target = BACKUP / path.relative_to(HOME)
        target.parent.mkdir(parents=True, exist_ok=True)
        BACKUP.chmod(0o700)
        if path.is_symlink():
            target.symlink_to(os.readlink(path))
        elif path.is_file():
            shutil.copy2(path, target)
        else:
            raise SystemExit(f'Refusing to replace directory: {path}')


def atomic_write(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as output:
        name = output.name
        output.write(content)
    os.replace(name, path)


def link(source, target, apply):
    if target.is_symlink() and target.resolve() == source.resolve():
        print(f'Already linked: {target}')
        return
    print(f'Link {target} -> {source}')
    if apply:
        backup(target)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.unlink(missing_ok=True)
        target.symlink_to(source)


def json_config(source, target, apply, wrapper=None):
    incoming = json.loads(source.read_text())
    old = json.loads(target.read_text()) if target.exists() else ({} if isinstance(incoming, dict) else [])
    new = merge(old, {wrapper: incoming}) if wrapper else (merge(old, incoming) if isinstance(incoming, dict) else incoming)
    print(f'Merge {source.relative_to(ROOT)} -> {target}' if isinstance(incoming, dict) else f'Replace keybindings: {target}')
    if apply and old != new:
        backup(target)
        atomic_write(target, (json.dumps(new, indent=2) + '\n').encode())


def preferences(group, apply):
    for source in sorted((ROOT / 'config' / group).glob('*.plist')):
        domain = source.stem
        print(f'Merge preferences: {domain}')
        if not apply:
            continue
        # Use cfprefsd through defaults, never overwrite a live plist file directly.
        result = subprocess.run(['defaults', 'export', domain, '-'], capture_output=True)
        if result.returncode and (HOME / 'Library/Preferences' / (domain + '.plist')).exists():
            raise SystemExit(f'Could not export existing preferences for {domain}; leaving unchanged.')
        current = plistlib.loads(result.stdout) if result.returncode == 0 else {}
        patch = plistlib.loads(source.read_bytes())
        backup_dir = BACKUP / 'preferences'
        backup_dir.mkdir(parents=True, exist_ok=True)
        BACKUP.chmod(0o700)
        (backup_dir / source.name).write_bytes(plistlib.dumps(current))
        with tempfile.NamedTemporaryFile(suffix='.plist') as output:
            output.write(plistlib.dumps(merge(current, patch)))
            output.flush()
            subprocess.run(['defaults', 'import', domain, output.name], check=True)


def ensure_closed(group):
    names = {'apps': ['AltTab', 'Rectangle'], 't3': ['T3 Code (Beta)', 'T3 Code'], 'handy': ['handy'], 'editors': ['Code', 'Cursor', 'zed'], 'karabiner': ['Karabiner-Elements']}.get(group, [])
    processes = subprocess.check_output(['ps', '-axo', 'comm='], text=True).splitlines()
    active = [name for name in names if any(Path(p.strip()).name == name for p in processes)]
    if active:
        raise SystemExit('Quit these apps before applying settings: ' + ', '.join(active))
    if group == 't3':
        # Desktop exit alone is not proof that the shared background server stopped.
        active = [p for p in processes if '/.t3/' in p or ('t3code' in p.lower() and '/node_modules/' in p)]
        if active:
            raise SystemExit('T3 background processes may still be running. Stop them through T3 before restoring settings.')
        print('T3: all desktop AND background/headless servers must be stopped before applying.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('group', choices=['dotfiles', 'apps', 'macos', 't3', 'handy', 'editors', 'karabiner', 'codex'])
    parser.add_argument('--apply', action='store_true')
    args = parser.parse_args()
    if args.apply:
        if subprocess.check_output(['uname', '-s'], text=True).strip() != 'Darwin':
            raise SystemExit('Apply is supported on macOS only.')
        ensure_closed(args.group)
    if args.group == 'dotfiles':
        mapping = {'.zprofile': '.zprofile', '.zshrc': '.zshrc', '.tmux.conf': '.tmux.conf', '.alacritty.toml': '.alacritty.toml', 'init.vim': '.config/nvim/init.vim', 'config/gitconfig': '.gitconfig', 'config/gitignore': '.config/git/ignore'}
        for source, target in mapping.items():
            link(ROOT / source, HOME / target, args.apply)
    elif args.group in ['apps', 'macos']:
        preferences(args.group, args.apply)
    elif args.group == 't3':
        for source in (ROOT / 'config/t3').glob('*.json'):
            json_config(source, HOME / '.t3/userdata' / source.name, args.apply)
    elif args.group == 'handy':
        json_config(ROOT / 'config/handy/settings.json', HOME / 'Library/Application Support/com.pais.handy/settings_store.json', args.apply, wrapper='settings')
    elif args.group == 'editors':
        # JSONC settings are copied, because stdlib JSON cannot safely merge JSONC.
        # Existing files are backed up, including the originally malformed keybindings header.
        for app in ['Code', 'Cursor']:
            for name in ['settings', 'keybindings']:
                link(ROOT / f'config/editors/{app.lower()}-{name}.json', HOME / f'Library/Application Support/{app}/User/{name}.json', args.apply)
        link(ROOT / 'config/editors/zed.json', HOME / '.config/zed/settings.json', args.apply)
    elif args.group == 'karabiner':
        link(ROOT / 'config/karabiner/karabiner.json', HOME / '.config/karabiner/karabiner.json', args.apply)
    elif args.group == 'codex':
        # A minimal starting point. Never overwrite an existing provider/project config.
        target = HOME / '.codex/config.toml'
        if target.exists() or target.is_symlink():
            print('Existing Codex config preserved. Compare config/codex/config.toml manually.')
        else:
            print(f'Copy initial Codex model preferences -> {target}')
            if args.apply:
                atomic_write(target, (ROOT / 'config/codex/config.toml').read_bytes())
    print(f'Backups (when needed): {BACKUP}' if args.apply else 'Preview only; add --apply to write.')


if __name__ == '__main__':
    main()
