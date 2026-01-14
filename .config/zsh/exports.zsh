export LIBRARY_PATH="/opt/homebrew/bin:/opt/homebrew/lib:$LIBRARY_PATH"

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

export EDITOR=nvim

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f "${CONFIG}/zsh/exports.sh.local" ] && source "${CONFIG}/zsh/exports.sh.local"
