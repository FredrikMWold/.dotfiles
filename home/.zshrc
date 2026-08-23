# If not running interactively, don't do anything

[[ $- != *i* ]] && return

# Add your own customizations below

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.dotfiles/oh-my-zsh/.oh-my-zsh/custom"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions command-not-found sudo zsh-syntax-highlighting fzf-tab)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH=~/.console-ninja/.bin:$PATH


alias cd='z'
alias ll='eza -lha'
alias ghp='vicinae cmd launch @knoopx/github:createPullRequest'
alias npmi='vicinae cmd launch @FredrikMWold/npm:npm-install'
alias npmr='vicinae cmd launch @FredrikMWold/npm:npm-uninstall'
alias npmu='vicinae cmd launch @FredrikMWold/npm:npm-update'



cc() {
    if [ -n "$1" ]; then
        cd "$1" && /usr/bin/code .
    else
        /usr/bin/code .
    fi
}
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"
