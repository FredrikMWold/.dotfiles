# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load omarchy-zsh configuration
if [[ -d /usr/share/omarchy-zsh/conf.d ]]; then
  for config in /usr/share/omarchy-zsh/conf.d/*.zsh; do
    [[ -f "$config" ]] && source "$config"
  done
fi

# Load omarchy-zsh functions and aliases
if [[ -d /usr/share/omarchy-zsh/functions ]]; then
  for func in /usr/share/omarchy-zsh/functions/*.zsh; do
    [[ -f "$func" ]] && source "$func"
  done
fi

# Add your own customizations below

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/home/fredrik/go/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=/home/fredrik/.local/kitty.app/bin:$PATH


export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.dotfiles/oh-my-zsh/.oh-my-zsh/custom"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions command-not-found sudo zsh-syntax-highlighting fzf-tab)

source $ZSH/oh-my-zsh.sh

export EDITOR='code'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH=~/.console-ninja/.bin:$PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias cd='z'
alias gc='branch-picker-tui'
alias wt='worktree-tui'
alias ll='eza -lha'

cc() {
    if [ -n "$1" ]; then
        cd "$1" && /usr/bin/code .
    else
        /usr/bin/code .
    fi
}