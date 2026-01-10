# timing startup command: time (zsh -i -c exit)

export CONFIG="$HOME/.config"

source "${CONFIG}/zsh/exports.zsh"

eval "$(starship init zsh)"

setopt EXTENDED_HISTORY
setopt autocd

autoload -U compinit; compinit

source <(fzf --zsh)

source "${CONFIG}/zsh/fzf-tab/fzf-tab.plugin.zsh"
source "${CONFIG}/zsh/.zshrc.local"
source "${CONFIG}/zsh/git/git.plugin.zsh"
source "${CONFIG}/zsh/aliases.zsh"
source "${CONFIG}/zsh/secrets.zsh"
