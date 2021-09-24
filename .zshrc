# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
export ZSH="/home/wilhelm/.oh-my-zsh"
export EDITOR=nvim
export VISUAL=nvim

ZSH_THEME="agnoster"

plugins=(
	git
	command-not-found
	web-search
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source /usr/share/doc/pkgfile/command-not-found.zsh

#CUSTOM
eval "$(zoxide init zsh)"

# aliases
alias v="nvim"
alias sudo="sudo "
bindkey '^e' end-of-line
