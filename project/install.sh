#!/bin/bash
# created by Jasti Sri Radhe Shyam (https://git.io/fjxPu)

alias python="python2"

# ----- color define [ start ] -----
color_blue='\033[0;34m'
color_red='\033[0;31m'
color_green='\033[0;32m'
color_none='\033[0m' # No Color
# ----- color define [ end ] -----

# indentaton configs
indent=$((0));
indent_char="\t";

# Iterating the options
for opt in "$@"
do
    # Check for echo option
    if [ "$opt" = "-v" -o "$opt" = "--verbose" ];then
        verbose_opt=1
    fi
done

dependencies_list=(git node docker docker-compose)
directories=(dir1 client server database)
git_directories=(client server database)
npm_directories=(client server)
git_client_remote="remote_client_url"
git_server_remote="remote_server_url"
git_database_remote="remote_database_url"
project_env=dev

# ----- message functions [ start ] -----

# shows the start messsage
function start_message() {
    local message=$1;
    local tab_count=$indent;
    local tab_string="";
    for(( ; tab_count > 0; tab_count-- ))
    do
        tab_string="$tab_string$indent_char";
    done
    ((indent++));

    echo -e "$tab_string${color_blue}[/]${color_none} $message"
}

# shows error message
function error_message() {
    local message=$1;
    local dont_indent_inc=$2;
    ((indent--));
    local tab_count=$indent;
    local tab_string="";
    for(( ; tab_count > 0; tab_count-- ))
    do
        tab_string="$tab_string$indent_char";
    done

    echo -e "$tab_string${color_red}[-]${color_none} $message"

    if [ "$dont_indent_inc" = "true" ]; then
        ((indent++))
    fi
}

# shows success message
function success_message() {
    local message=$1;
    local dont_indent_inc=$2;
    ((indent--));
    local tab_count=$indent;
    local tab_string="";
    for(( ; tab_count > 0; tab_count-- ))
    do
        tab_string="$tab_string$indent_char";
    done 

    echo -e "$tab_string${color_green}[+]${color_none} $message"

    if [ "$dont_indent_inc" = "true" ]; then
        ((indent++))
    fi 
}

# ----- message functions [ end ] -----

# ------ functions | start | ------

# static use variables
static_git_additions_count=0;


# check the progarm exists or not
function check_program() {
    local program_name=$1;
    if [ "$verbose_opt" = 1 ]; then
        which $program_name;
    else
        # sending output to null
        which $program_name > /dev/null 2>&1;
    fi
    return $?;
}

# check for the applications
function check_dependencies() {
    local installed_flag=0;

    start_message "checking dependencies"
    # iterating the dependencies
    for dependency in ${dependencies_list[*]}
    do
        # checking the program availabily
        check_program $dependency
        
        # check if which is success
        if [ $? -ne 0 ]; then
            error_message "$dependency not installed" "true"
            installed_flag=1
        fi
    done
    
    # check if any of the program is not installed
    if [ "$installed_flag" -ne 0 ]; then
        error_message "install dependencies first"
        exit 3;
    else
        success_message "done checking dependencies"
    fi
}

# creats directory if not persisted
function mkdir_if_not_created() {
    local DIRECTORY=$1
    if [ ! -d "$DIRECTORY" ]; then
        if [ "$verbose_opt" = 1 ]; then
            mkdir $DIRECTORY
        else
            mkdir $DIRECTORY > /dev/null 2>&1
        fi
    fi
    if [ $? -ne 0 ]; then
        return 1;
    fi
}

# deletes a dir if present
function delete_dir() {
    local directory=$1
    if [ -d "$directory" ]; then
        if [ "$verbose_opt" = 1 ]; then
            rm -rf $directory
        else
            rm -rf $directory > /dev/null 2>&1
        fi
        if [ $? -ne 0 ]; then
            return 1;
        fi
    fi
}

# add git repository and configures it
function git_additions() {
    local application=$1
    local git_remote=origin
    local git_remote_url=$2
    local branch=$3
    local run_again=false
    static_git_additions_count=$((static_git_additions_count + 1))

    #  changing directory
    if [ "$verbose_opt" = 1 ]; then
        cd $application
    else
        cd $application > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        return 1;
    fi

    # initialize git
    if [ ! -d ".git" ]; then
        if [ "$verbose_opt" = 1 ]; then
            git init
        else
            git init > /dev/null 2>&1
        fi
        if [ $? -ne 0 ]; then
            return 1;
        fi
    fi
    
    # add remote
    if [ ! "$(git remote -v | grep $git_remote_url)" ]; then
        if [ "$verbose_opt" = 1 ]; then
            git remote add $git_remote $git_remote_url
        else
            git remote add $git_remote $git_remote_url > /dev/null 2>&1
        fi
        if [ $? -ne 0 ]; then
            run_again=true
        fi
    fi
    
    # check out the branch
    if [ ! "$(git branch -v | grep "* $branch")" ]; then
        if [ "$verbose_opt" = 1 ]; then
            git checkout -b $branch
        else
            git checkout -b $branch > /dev/null 2>&1
        fi
        if [ $? -ne 0 ]; then
            run_again=true
        fi
    fi

    # pull the branch
    if [ "$verbose_opt" = 1 ]; then
        git pull $git_remote $branch
    else
        git pull $git_remote $branch > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        run_again=true
    fi

    cd ..
    if [ "$run_again" = true -a $static_git_additions_count -gt 0 -a $static_git_additions_count -lt 10 ]; then
        git_additions $1 $2 $3 $4
    elif [ "$run_again" = true ]; then
        static_git_additions_count=0
        return 1;
    else
        static_git_additions_count=0
    fi
}

# install node dependencies
function install_node() {
    local application=$1;
    
    # changing directory
    if [ "$verbose_opt" = 1 ]; then
        cd $application
    else
        cd $application > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        return 1;
    fi

    # npm install
    if [ "$verbose_opt" = 1 ]; then
        npm i
    else
        npm i > /dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        return 1;
    fi
    
    cd ..;
}

function create_directories(){
    for directory in ${directories[*]}
    do
        start_message "creating directory $directory"
        mkdir_if_not_created $directory
        if [ $? -ne 0 ]; then
            error_message "error while creating directory $directory"
            exit 3;
        else
            success_message "done creating directory $directory"
        fi
    done
}

# git addition
function add_git() {
    for git_directory in ${git_directories[*]}
    do
        start_message "adding git to $git_directory"
        local git_remote_variable="git_${git_directory}_remote"
        local git_remote_url="${!git_remote_variable}"
        local branch=$project_env
        git_additions $git_directory $git_remote_url $branch
        if [ $? -ne 0 ]; then
            error_message "error while adding git to $git_directory"
        else
            success_message "done adding git to $git_directory"
        fi
    done
}

# installing node dependencies
function add_node_packages() {
    for npm_directory in ${npm_directories[*]}
    do
        start_message "installing npm packages in $npm_directory"
        install_node $npm_directory
        if [ $? -ne 0 ]; then
            error_message "error while installing npm packages in $npm_directory"
        else
            success_message "done installing npm packages in $npm_directory"
        fi
    done
}
# ------ Functions | end | ------

# ------ functions execution | start | ------

#checking application dependencies
check_dependencies

# creating directories
create_directories

# delete the repo data
delete_dir .git

# add git
add_git

# add node packages
add_node_packages
# ------ functions execution | end | ------

# ----- end of file -----