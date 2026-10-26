# Will's MacBook setup

Dotfiles and a rebuild recipe based on an audit of the actual Apple Silicon laptop on **21 October 2026**, running macOS 26.6.2. The aim is to recover the same keyboard workflow, terminal appearance, personal app forks and development tools on a new Mac.

## Start on a new Mac

1. Finish macOS setup, sign in to your Apple account and install available updates.
2. Install Apple's Command Line Tools (`xcode-select --install`) and wait for installation to finish.
3. Clone this public repo without needing GitHub authentication:

   ```sh
   mkdir -p ~/Projects
   git clone https://github.com/BreakTheBeta/Configurations.git ~/Projects/Configurations
   cd ~/Projects/Configurations
   ./setup.sh                  # preview; no changes
   ./setup.sh --apply          # core packages, shell/plugin managers, backed-up dotfile links
   ```

4. Follow [the new Mac checklist](docs/new-mac.md) for Alacritty, both personal forks, app settings, permissions, keyboard remaps, login items and accounts. These steps are essential to making the machine feel the same.
5. Optionally run `./setup.sh --apply --extras` for the larger development/personal app collection. Use `./setup.sh --apply --config-only` to link dotfiles without installing packages or downloading plugin managers.
6. Run `./scripts/doctor.sh` and the hands-on checks in the checklist.

Homebrew and package installers may request administrator authentication. The setup uses [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) with `--no-upgrade`: existing packages are preserved. It never cleans up packages or starts services. This is a current installation recipe, not a byte-for-byte system image; inventory files record the old versions for comparison.

## What is captured

- Zsh + Oh My Zsh/robbyrussell + zsh-vi-mode + zoxide; private overrides in `~/.zshrc.local`.
- Alacritty font, colours, opacity and tmux shortcuts; tmux Ctrl-F prefix, Vim navigation, resize keys and plugins.
- Live Neovim config with installed plugin commits pinned; VS Code, Cursor and Zed settings and extension lists.
- Rectangle's Ctrl-Option-H/L split shortcuts and other explicit preferences; Based AltTab (the ad-free AltTab fork to install, see `docs/forks.md`) and shortcut archives.
- T3 Code Fold's UI preferences, keybindings and folded project settings, plus its source revision and build recipe.
- Handy's Fn toggle, language/model choice and paste behaviour; standalone Tailscale installation and manual enrolment steps.
- Explicit macOS preferences, per-keyboard modifier inventory, fonts, app/package inventories and an optional software collection.

The old `.alacritty.yml` remains as a historical reference; the installer uses `.alacritty.toml`. The old `vscode.json` entry point now matches the captured VS Code settings.

## Apply settings individually

Every command below previews until `--apply` is appended. Quit the affected apps first. In particular, apply T3 settings **before launching T3 on the new Mac**, or after stopping all its desktop and background servers. Do not apply these commands inside the live T3 session that is running your agent.

```sh
python3 scripts/configure.py apps        # AltTab + Rectangle, merging only captured keys
python3 scripts/configure.py macos       # repeat rate, Dark appearance, Dock/Finder/Fn/hotkeys
python3 scripts/configure.py editors     # VS Code, Cursor, Zed (backs up then replaces settings)
python3 scripts/configure.py handy       # merges public settings, preserves other settings
python3 scripts/configure.py t3          # merges UI settings; replaces keybinding array
python3 scripts/configure.py karabiner   # optional: currently just an empty ANSI profile
python3 scripts/configure.py codex       # initial model preferences, only if config is absent
python3 scripts/checkout-forks.py        # preview pinned source clones
```

Settings groups are opt-in because they can change keyboard shortcuts or replace existing editor customizations. Files are linked to this checkout, so keep it in a permanent location. T3 and Handy settings are merged into regular files because those apps write their own settings. Editor apps may replace symlinks when saving settings; rerun the editors group to relink after reviewing local changes.

Backups go to `~/.config-backups/<timestamp>-<pid>/`, preserving relative paths; preference exports go in its `preferences/` subdirectory. To undo a dotfile link, remove that symlink and copy its saved file (or recreate its saved symlink) back. Quit the app before restoring its JSON file. Restore a preference export with `defaults import DOMAIN BACKUP.plist`; log out/in after changing macOS settings. No unrelated preferences are deleted by the installer.

## Public and private boundaries

This is a **public** repo. It includes selected settings rather than whole application support directories. Never commit credentials, SSH/GPG keys, browser profiles, `.env` files, work completion scripts, shell history, recordings, model binaries, Tailscale node state, T3 databases, connection catalogs, tokens or secrets. Reauthenticate on the new machine. Existing Git identity and work aliases are backed up when linking dotfiles; put them into `~/.gitconfig.local` and `~/.zshrc.local` after review. See [private migration](docs/private-migration.md).

[Software inventory and manual apps](docs/software.md) · [Personal forks](docs/forks.md) · [New Mac checklist](docs/new-mac.md)

## Validation

The audit checked all 85 enabled Brewfile entries against Homebrew's API, validated shell/config syntax, exercised previews, ran the config-only bootstrap against a temporary home, and passed five focused tests covering backups, repeat runs, JSON/preference merging, invalid input and blocking a running T3 desktop. Public exports were allowlisted and scanned for common credential patterns. Run `python3 -m unittest discover -s scripts -p 'test_*.py'` to repeat those tests on macOS.

A complete install on a blank Mac, full fork builds, Neovim plugin downloads and GUI permission/login flows were not performed. The checklist records those remaining hardware/account checks explicitly.
