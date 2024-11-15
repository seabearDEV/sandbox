#!/bin/zsh

## Zsh options
autoload bashcompinit

## Zsh command history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=50000
setopt appendhistory

## Zsh variables
REPOSITORY="$HOME/Projects/github.com/seabearDEV/system-config"
PROJECT="configurations/zsh"

## Zsh aliases
alias sq="$HOME/Projects/github.com/seabearDEV/sandbox/stocks/stock-quote.sh"
alias zshd="cp $REPOSITORY/$PROJECT/zshrc ~/.zshrc && source ~/.zshrc"

## Zsh sb-zsh scripts
source "$HOME/.sb-zsh/sb-zsh.zsh"

## Homebrew Zsh scripts
HOMEBREW_SCRIPTS=(
    $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

# Load Homebrew scripts if they exist
for script in $HOMEBREW_SCRIPTS; do
    if [[ -f $script ]]; then
        source $script
    fi
done

## Starship
# Initialize Starship
eval "$(starship init zsh)"

## NVM
# Set NVM directory
export NVM_DIR="$HOME/.nvm"

# Load nvm if it exists
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"

# Load nvm bash_completion if it exists
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
