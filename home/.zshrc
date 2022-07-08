PROMPT='
%K{blue}%*%k %F{black}%K{white}%.%k%f %% '

export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

eval "$(rbenv init -)"
eval "$(nodenv init -)"
eval "$(goenv init -)"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH=$GOPATH/.dotfiles/bin:$PATH
export PATH=$HOME/.dotfiles/bin:$PATH

# completion
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

autoload -U compinit
compinit -u

mkcd () { mkdir $1; cd $1 }

# aliases
alias ll='ls -la'
alias grep='grep -v grep | grep'
alias gdiff='git diff --no-index'
alias chrome='open -a "Google Chrome.app"'
alias safari='open -a "safari.app"'

## Git
alias g='gitup'
alias gf='git fetch -p'
alias gr='git reset'
alias gri='git rebase -i'
alias gpf='git push -f'
alias gc='git checkout'
alias gm='git merge'
alias gl='git log --oneline --graph --decorate'
alias git-branch-default='git remote show origin | grep "HEAD branch" | sed "s/.*: //"'
alias git-branch-delete-merged='git branch --merged | egrep -v "(\*|$(git-branch-default))" | xargs git branch -d'
alias git-reg='gf && git add . && git stash && git checkout $(git-branch-default) && git merge origin/$(git-branch-default) && git-branch-delete-merged && git stash pop'
alias git-open-diff-file='code $(git diff `git show-branch --merge-base $(git-branch-default) HEAD` HEAD --name-only)'

alias gp="gh pr create --draft --fill --body-file .github/PULL_REQUEST_TEMPLATE.md ; gh pr view --web"
alias gpl="gh pr list --search '-label:dependencies'"
alias gplt="gh pr list --state 'all' --search 'author:@me updated:$(date +%Y-%m-%d)'"

## JavaScript
alias y='yarn'
alias yd='yarn dev'
alias yt='yarn test'
alias yl='yarn lint'

## Ruby
alias be='bundle exec'

## Flutter
alias f='fvm flutter'

source ~/Documents/dotfiles-secrets/.zshrc-secrets
