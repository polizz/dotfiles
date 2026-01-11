
# TLDR Dotfiles

1. Install GNU stow
  `brew install stow`
2. Run stow in .dotfiles
  `stow .`


To delete all symlinks:
  `stow -D .`

# Overview


Everything in this folder (besides stow-ignored files) are symlinked into parent directory. i.e. .zshrc gets symlinked to ~/.zshrc since this repo SHOULD be cloned to the home direct as ~/.dotfiles.

The .config directory here is likewise symlinked to ~/.config - so the paths in .zshrc that point to ${CONFIG}/zsh/aliases.sh, for instance, resolve properly to the project folder ./config/zsh.

GNU stow merges the symlinks it creates with existing files/dirs, so machine-specific files, such as secrets.zsh and .zshrc.local should be created under ~/.config/zsh/.


# Update git subtree for fzf

`git subtree pull --prefix .config/zsh/fzf-tab https://github.com/Aloxaf/fzf-tab master --squash`
