#!/bin/sh

# git remote
gitremote=origin

# git current branch (works on both gawk and mawk)
alias git_cur_branch="git branch | awk '/^\\*/{print \$2}'"

# git pull current branch
alias gplc="git pull $gitremote \$(git_cur_branch)"

# git push current branch 
alias gphc="git push $gitremote \$(git_cur_branch)"

# git files affected in perticular commit
alias gchf_commit="git diff-tree --no-commit-id --name-only -r"

# git commit with gpg keys with different keys
alias gc_office="git commit -s -SGPG_KEY_OFFICE"
alias gc_personal="git commit -s -SGPG_KEY_PERSONAL"

# enable if force gpg passphrase retrival from terminal
# export GPG_TTY=$(tty)
