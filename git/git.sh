#!/bin/sh

# git remote
gitremote=origin

# git pull current branch
alias gplc="git pull $gitremote $(git branch | awk '/*/ {print $2}')"

# git push current branch 
alias gphc="git push $gitremote $(git branch | awk '/*/ {print $2}')"

# git commit with gpg keys with different keys
alias gco="git commit -SGPG_KEY_OFFICE"
alias gcp="git commit -SGPG_KEY_PERSONAL"