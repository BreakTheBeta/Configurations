#!/bin/bash
# Read-only checks; no secrets, tailnet addresses or account information printed.
set -uo pipefail
failures=0
check() {
  if "$@" >/dev/null 2>&1; then echo "OK: $*";
  else echo "CHECK: $*"; failures=$((failures + 1)); fi
}
for cmd in brew git gh tmux nvim rg jq zoxide node python3 codex; do check command -v "$cmd"; done
for file in .zshrc .zprofile .tmux.conf .alacritty.toml .config/nvim/init.vim .oh-my-zsh/oh-my-zsh.sh .oh-my-zsh/custom/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh .tmux/plugins/tpm/tpm .local/share/nvim/site/autoload/plug.vim; do check test -r "$HOME/$file"; done
for app in Alacritty AltTab Rectangle Tailscale Handy 'T3 Code (Beta)'; do check test -d "/Applications/$app.app"; done
check test -d /Applications/Xcode.app
check /usr/libexec/java_home -v 17
check gh auth status
check codex login status
check /Applications/Tailscale.app/Contents/MacOS/Tailscale status --json
# Assert the font family that the terminal actually requests.
check /bin/bash -c 'system_profiler SPFontsDataType | rg -q "DejaVuSansM Nerd Font Mono"'
echo 'Manually verify permissions, Handy model download, fork provenance, and shortcuts with docs/new-mac.md.'
exit "$((failures > 0))"
