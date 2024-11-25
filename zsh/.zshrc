#!/bin/zsh

# Debug mode flag - set to true to show loading time
SHOW_LOADING_TIME=false

# Source debug configuration if it exists
[[ -f ~/.zsh_debug ]] && source ~/.zsh_debug

# Start timing only if debug mode is enabled
[[ "$SHOW_LOADING_TIME" = true ]] && zmodload zsh/datetime && start_time=$EPOCHREALTIME

## Zsh options
autoload bashcompinit 2>/dev/null || echo "Warning: Failed to load bashcompinit"
bashcompinit

## Zsh command history settings
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=500000
setopt appendhistory

## Zsh variables
REPOSITORY="${HOME}/Projects/github.com/seabearDEV/system-config"
PROJECT="configurations/zsh"

# Cache Homebrew prefix
BREW_PREFIX="/usr/local"
[[ -d "/opt/homebrew" ]] && BREW_PREFIX="/opt/homebrew"

## Zsh aliases
alias sq="${HOME}/Projects/github.com/seabearDEV/sandbox/stocks/stock-quote.sh"
alias zshd="[[ -f '$REPOSITORY/$PROJECT/zshrc' ]] && { cp '$REPOSITORY/$PROJECT/zshrc' ~/.zshrc && source ~/.zshrc } || echo 'Error: Source zshrc not found'"

# Debug mode toggle aliases
alias debug-on="echo 'export SHOW_LOADING_TIME=true' > ~/.zsh_debug && source ~/.zsh_debug && source ~/.zshrc"
alias debug-off="echo 'export SHOW_LOADING_TIME=false' > ~/.zsh_debug && source ~/.zsh_debug && source ~/.zshrc"
alias debug-status="echo 'Debug mode is currently: ${SHOW_LOADING_TIME}'"

## Zsh sb-zsh scripts
[[ -f "${HOME}/.sb-zsh/sb-zsh.zsh" ]] && source "${HOME}/.sb-zsh/sb-zsh.zsh"

## Homebrew sbin PATH
export PATH="/usr/local/sbin:$PATH"

## Homebrew Zsh scripts
# Source autosuggestions (keep this loaded immediately for better experience)
[[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

## Lazy load Starship
prompt_starship_precmd() {
    eval "$(starship init zsh)"
    precmd_functions=(${precmd_functions:#prompt_starship_precmd})
}
[[ -x "$(command -v starship)" ]] && precmd_functions+=(prompt_starship_precmd)

## NVM Lazy Loading
export NVM_DIR="${HOME}/.nvm"
[[ -d "$NVM_DIR" ]] || mkdir -p "$NVM_DIR"

# Create lazy loading function for nvm
nvm() {
    unset -f nvm node npm npx
    [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && source "$BREW_PREFIX/opt/nvm/nvm.sh"
    [ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
    nvm "$@"
}

# Create lazy loading functions for node-related commands
node() {
    unset -f nvm node npm npx
    [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && source "$BREW_PREFIX/opt/nvm/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && source "$BREW_PREFIX/opt/nvm/nvm.sh"
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && source "$BREW_PREFIX/opt/nvm/nvm.sh"
    npx "$@"
}

## Defer syntax highlighting (should be last)
defer_syntax_highlighting() {
    [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    precmd_functions=(${precmd_functions:#defer_syntax_highlighting})
}
precmd_functions+=(defer_syntax_highlighting)

# End timing and print result only if debug mode is enabled
if [[ "$SHOW_LOADING_TIME" = true ]]; then
    end_time=$EPOCHREALTIME
    printf "Shell Loading time: %.3f seconds\n" $(($end_time - $start_time))
fi
