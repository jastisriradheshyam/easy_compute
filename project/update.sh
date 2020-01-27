#!/bin/bash

# Iterating the options
for opt in "$@"
do
    # Check for echo option
    if [ "$opt" = "-v" -o "$opt" = "--verbose" ];then
        verbose_opt=1
    fi
done

# ----- color define [ start ] -----
color_blue='\033[0;34m'
color_red='\033[0;31m'
color_green='\033[0;32m'
color_none='\033[0m' # No Color
# ----- color define [ end ] -----

# ----- directories ------
directories=(client server database)

# git update by pulling
function git_update() {
    local directory=$1
    if [ "$verbose_opt" = 1 ]; then
        cd $directory
    else
        cd $directory > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        return 1;
    fi
    local git_remote=origin
    local branch=$(git branch | awk '/*/ {print $2}')
    local run_again=false
    static_git_additions_count=$((static_git_additions_count + 1))
    if [ "$verbose_opt" = 1 ]; then
        git pull -q $git_remote $branch
    else
        git pull -q $git_remote $branch > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        run_again=true
    fi
    cd ..
    if [ "$run_again" = true -a $static_git_additions_count -gt 0 -a $static_git_additions_count -lt 10 ]; then
        git_update $1
    else
        static_git_additions_count=0
        if [ "$run_again" = true ]; then
            return 1;
        fi
    fi
}

# iterating all the applications or directories
for directory in ${directories[*]}
do
    echo -e "${color_blue}[/]${color_none} updating $directory"
    git_update $directory
    if [ $? -ne 0 ]; then
        echo -e "${color_red}[-]${color_none} error while updating $directory"
    else
        echo -e "${color_green}[+]${color_none} done updating $directory"
    fi
done