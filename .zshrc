# timing startup command: time (zsh -i -c exit)

export CONFIG="$HOME/.config"

source "${CONFIG}/zsh/exports.zsh"

eval "$(starship init zsh)"

setopt EXTENDED_HISTORY
setopt autocd

autoload -U compinit; compinit
#
# Ctrl+X+e to edit command line in neovim
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

source <(fzf --zsh)

# Enable hidden files in Zsh completion
_comp_options+=(globdots)

[ -f "${CONFIG}/zsh/fzf-tab/fzf-tab.plugin.zsh" ] && source "${CONFIG}/zsh/fzf-tab/fzf-tab.plugin.zsh"
[ -f "${CONFIG}/zsh/.zshrc.local" ] && source "${CONFIG}/zsh/.zshrc.local"
[ -f "${CONFIG}/zsh/git/git.plugin.zsh" ] && source "${CONFIG}/zsh/git/git.plugin.zsh"
[ -f "${CONFIG}/zsh/aliases.zsh" ] && source "${CONFIG}/zsh/aliases.zsh"
[ -f "${CONFIG}/zsh/secrets.zsh" ] && source "${CONFIG}/zsh/secrets.zsh"
