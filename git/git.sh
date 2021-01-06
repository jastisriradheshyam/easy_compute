#!/bin/sh

# git remote
gitremote=origin

# git pull current branch
alias gplc="git pull $gitremote \$(git branch | awk '/*/ {print \$2}')"

# git push current branch 
alias gphc="git push $gitremote \$(git branch | awk '/*/ {print \$2}')"

# git files affected in perticular commit
alias gchf_commit="git diff-tree --no-commit-id --name-only -r"

# git commit with gpg keys with different keys
alias gco="git commit -SGPG_KEY_OFFICE"
alias gcp="git commit -SGPG_KEY_PERSONAL"
