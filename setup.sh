#!/bin/bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "$0")" && pwd)"
apply=0; extras=0; config_only=0
for arg in "$@"; do
  case "$arg" in
    --apply) apply=1 ;;
    --extras) extras=1 ;;
    --config-only) config_only=1 ;;
    --help|-h) echo 'Usage: ./setup.sh [--apply] [--extras] [--config-only]'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done
if [[ "$apply" == 0 ]]; then
  echo 'Preview only. Add --apply to execute.'
  echo 'Install Command Line Tools/Homebrew if needed; install Brewfile (without upgrades).'
  [[ "$extras" == 0 ]] || echo 'Also install Brewfile.extras.'
  [[ "$config_only" == 0 ]] || echo 'Config only: skip Homebrew and plugin downloads.'
  echo 'Back up and link shell, tmux, Alacritty, Neovim and Git defaults.'
  echo 'Clone Oh My Zsh, zsh-vi-mode, tmux plugins and vim-plug when missing.'
  echo 'App preferences, T3, Handy, editors, macOS defaults and fork builds are separate steps: README.md.'
  exit 0
fi
[[ "$(uname -s)" == Darwin ]] || { echo 'This setup targets macOS.' >&2; exit 1; }
if [[ "$config_only" == 0 ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo 'Finish Command Line Tools installation, then rerun setup.'
    exit 1
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)";
  elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)";
  else
    installer="$(mktemp)"
    trap 'rm -f "$installer"' EXIT
    curl -fL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
    /bin/bash "$installer"
    if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)";
    else eval "$(/usr/local/bin/brew shellenv)"; fi
  fi
  brew bundle install --file="$ROOT/Brewfile" --no-upgrade
  [[ "$extras" == 0 ]] || brew bundle install --file="$ROOT/Brewfile.extras" --no-upgrade
  clone_missing() {
    if [[ -e "$2" ]]; then echo "Keeping existing $2";
    else git clone --depth=1 "$1" "$2"; fi
  }
  clone_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  mkdir -p "$HOME/.oh-my-zsh/custom/plugins" "$HOME/.tmux/plugins"
  clone_missing https://github.com/jeffreytse/zsh-vi-mode.git "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
  clone_missing https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
  clone_missing https://github.com/tmux-plugins/tmux-sensible.git "$HOME/.tmux/plugins/tmux-sensible"
  plug="$HOME/.local/share/nvim/site/autoload/plug.vim"
  if [[ ! -e "$plug" ]]; then
    mkdir -p "$(dirname "$plug")"
    curl -fL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o "$plug"
  fi
fi
command -v python3 >/dev/null || { echo 'Install Python 3 (brew install python), then rerun.' >&2; exit 1; }
python3 "$ROOT/scripts/configure.py" dotfiles --apply
printf '\nRead README.md to finish fork apps, preferences, plugins, logins and permissions.\n'
