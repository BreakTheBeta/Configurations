if ! /bin/pwd -P >/dev/null 2>&1; then builtin cd -- "$HOME"; fi
# Interactive non-login shells (including agent terminals) also need Homebrew.
if (( ! $+commands[brew] )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)";
  elif [[ -x /usr/local/bin/brew ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-vi-mode)
export VI_MODE_SET_CURSOR=true
export MODE_INDICATOR="%F{white}+%f"
export INSERT_MODE_INDICATOR="%F{yellow}I%f"
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
export EDITOR="nvim" VISUAL="nvim"
export _ZO_RESOLVE_SYMLINKS=1
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
export KEYTIMEOUT=1
bindkey '^e' end-of-line
alias v=nvim
alias sudo='sudo '
alias gs='git status'
alias gch='git checkout'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias grc='git rebase --continue'
alias k=kubectl
alias kc='kubectl config'
alias lat='latexmk -interaction=nonstopmode -pvc -pdf'
alias ranger='. ranger'
alias pd=podman
alias venv='source .venv/bin/activate'
alias pypath='export PYTHONPATH=.'
alias codeServer='llama-server -hf ggml-org/Qwen2.5-Coder-7B-Q8_0-GGUF --port 8012 -ngl 99 -fa -ub 1024 -b 1024 --ctx-size 0 --cache-reuse 256'
typeset -U path
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.tfenv/bin" "$HOME/.lmstudio/bin" "$HOME/go/bin" "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $path)
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  for directory in "$HOMEBREW_PREFIX/opt/libpq/bin" "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" "$HOMEBREW_PREFIX/opt/gradle@6/bin" "$HOMEBREW_PREFIX/opt/rustup/bin"; do
    [[ -d "$directory" ]] && path=("$directory" $path)
  done
  for script in "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc" "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"; do
    [[ -r "$script" ]] && source "$script"
  done
fi
if /usr/libexec/java_home -v 17 >/dev/null 2>&1; then
  export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
  path=("$JAVA_HOME/bin" $path)
fi
export NVM_DIR="$HOME/.nvm"
[[ -s "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm/nvm.sh" ]] && source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/nvm/nvm.sh"
export GOENV_ROOT="$HOME/.goenv"
if [[ -x "$GOENV_ROOT/bin/goenv" ]]; then
  path=("$GOENV_ROOT/bin" $path)
  eval "$(goenv init -)"
fi
# Credentials, work aliases, private hosts, and machine-specific paths belong here.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
