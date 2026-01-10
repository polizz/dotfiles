alias ai='aider --architect --model openrouter/google/gemini-2.5-pro-preview --editor-model openrouter/anthropic/claude-sonnet-4 --vim --light-mode --cache-prompts --no-stream --no-auto-commits'
# alias ai='aider --architect --model openrouter/deepseek/deepseek-r1 --editor-model openrouter/anthropic/claude-3.7-sonnet:beta --vim --light-mode --cache-prompts --no-stream --no-auto-commits --no-git'
# alias ai='aider  --model openrouter/anthropic/claude-3.5-sonnet --vim --light-mode --cache-prompts --no-stream --no-auto-commits --no-git'
# alias ai='aider --architect --model openai/o1 --editor-model qwen/qwen-2.5-coder-32b-instruct --vim --light-mode --cache-prompts --no-stream --no-auto-commits --no-git'
# alias ai='aider --architect --model openai/o1 --editor-model qwen/qwen-2.5-coder-32b-instruct --vim --light-mode --cache-prompts --no-stream --no-auto-commits --no-git'
# alias nvim='NVIM_APPNAME=astronvim_v5 nvim'

alias rr='rm -rf'
alias gconfig='git config --local --add user.name polizz && git config --local --add user.email firebomb@gmail.com'
alias pullr='git fetch upstream -v; git rebase upstream/master'
alias pullbo='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias rr='rm -rf'

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcf='git config --list'
alias gco='git checkout'
# alias gcms='git commit -S -m'
# alias grh='git reset HEAD'
# alias grhh='git reset HEAD --hard'
# alias gpsup='git push --set-upstream origin $(current_branch)'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrl='npm run lint'
alias nrt='npm run test'

#alias ll='ls -al'
alias ll='eza -al'
# alias gd='git diff $1 ":(exclude)package-lock.json"'
alias gd='f() { git diff "${1:-HEAD}" -- . ":!package-lock.json"; }; f'
alias glog='g log'
alias ni='npm install -S'
alias nid='npm install -D'
alias nig='npm install -G'

alias n='nerdctl'
alias gcma='g commit --amend'

alias zb='zig build'

alias cr='cargo run'
alias cb='carbo build'
alias cbr='cargo build --release'

function ct() {
  cargo test $1
}
alias ctq='cargo test -q'
function ctn() {
  cargo test $1 -- --nocapture
}

