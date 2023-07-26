# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
export ZSH="/home/wilhelm/.oh-my-zsh"

export EDITOR=nvim
export VISUAL=nvim


ZSH_THEME="robbyrussell"

plugins=(
  git
	#command-not-found
  #vi-mode
  zsh-vi-mode
	zsh-autosuggestions
	zsh-syntax-highlighting

)

export VI_MODE_SET_CURSOR=true
export MODE_INDICATOR="%F{white}+%f"
export INSERT_MODE_INDICATOR="%F{yellow}I%f"

source $ZSH/oh-my-zsh.sh

#CUSTOM
eval "$(zoxide init zsh)"

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"


# Improves zsh autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bfd4f5,underline"

# Remove forward-char widgets from ACCEPT
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#vi-forward-char}")

# Add forward-char widgets to PARTIAL_ACCEPT
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(vi-forward-char)

export KEYTIMEOUT=1


bindkey '^e' end-of-line

alias v="nvim"
alias sudo="sudo "

export NVM_DIR=~/.nvm
#source $(brew --prefix nvm)/nvm.sh
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

alias gs="git status"
alias gch="git checkout"

alias ga="git add"
alias gaa="git add -A"

alias gp="git pull"
alias gc="git commit -m"

alias grc="git rebase --continue"

alias k="kubectl"
alias kc="kubectl config"
source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell

# Ranger
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

