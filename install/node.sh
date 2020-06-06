#!/bin/bash
# written by Jasti Sri Radhe Shyam

function printHelp() {
    cat <<EOL
        Usage:
            node.sh [Flags]

            Flags:
                -h   print help
                -ver set the node version to install
                     DEFAULT - 10.16.3
                -p   set the package manager
                     1 - APT
                     2 - EOPKG
                     Default - APT (1)
                -v   verbose
EOL
}

# parse flags

while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
    -h)
        printHelp
        exit 0
        ;;
    -ver)
        node_version="$2"
        shift
        ;;
    -p)
        package_mgr="$2"
        shift
        ;;
    -v)
        verbose_opt=1
        shift
        ;;
    *)
        echo
        echo "Unknown flag: $key"
        echo
        printHelp
        exit 1
        ;;
    esac
    shift
done

# configs
: ${node_version:="10.16.3"}

# 1 --> apt
# 2 --> eopkg
: ${package_mgr:=1}

dependencies_list=(curl tar)

# indentaton configs
indent=$((0))
indent_char="\t"

# ----- color define [ start ] -----
color_blue='\033[0;34m'
color_red='\033[0;31m'
color_green='\033[0;32m'
color_none='\033[0m' # No Color
# ----- color define [ end ] -----

# ----- message functions [ start ] -----

# shows the start messsage
function start_message() {
    local message=$1
    local tab_count=$indent
    local tab_string=""
    for (( ; tab_count > 0; tab_count--)); do
        tab_string="$tab_string$indent_char"
    done
    ((indent++))

    echo -e "$tab_string${color_blue}[/]${color_none} $message"
}

# shows error message
function error_message() {
    local message=$1
    local dont_indent_inc=$2
    ((indent--))
    local tab_count=$indent
    local tab_string=""
    for (( ; tab_count > 0; tab_count--)); do
        tab_string="$tab_string$indent_char"
    done

    echo -e "$tab_string${color_red}[-]${color_none} $message"

    if [ "$dont_indent_inc" = "true" ]; then
        ((indent++))
    fi
}

# shows success message
function success_message() {
    local message=$1
    local dont_indent_inc=$2
    ((indent--))
    local tab_count=$indent
    local tab_string=""
    for (( ; tab_count > 0; tab_count--)); do
        tab_string="$tab_string$indent_char"
    done

    echo -e "$tab_string${color_green}[+]${color_none} $message"

    if [ "$dont_indent_inc" = "true" ]; then
        ((indent++))
    fi
}

# ----- message functions [ end ] -----

# check the progarm exists or not
function check_program() {
    local program_name=$1
    if [ "$verbose_opt" = 1 ]; then
        which $program_name
    else
        # sending output to null
        which $program_name >/dev/null 2>&1
    fi
    return $?
}

# check for the applications
function check_dependencies() {
    local installed_flag=0

    start_message "checking dependencies"
    # iterating the dependencies
    for dependency in ${dependencies_list[*]}; do
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
        exit 3
    else
        success_message "done checking dependencies"
    fi
}

# download the node tar ball
function download_node() {
    start_message "downloading node"
    if [ "$verbose_opt" = 1 ]; then
        curl -O https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz
    else
        curl -O https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.xz >/dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        error_message "error down loading node"
        exit 3
    else
        success_message "done downloading node"
    fi
}

# extract the node tar ball
function extract_node() {
    start_message "extracting node"
    if [ "$verbose_opt" = 1 ]; then
        tar -C /usr/local --strip-components 1 -xvf node-v$node_version-linux-x64.tar.xz
    else
        tar -C /usr/local --strip-components 1 -xf node-v$node_version-linux-x64.tar.xz >/dev/null 2>&1
    fi
    if [ $? -ne 0 ]; then
        error_message "error extracting node"
        exit 3
    else
        success_message "done extracting node"
    fi
}

# download the tar and extract the node tar ball
function download_and_extract_node() {
    start_message "installing node js"
    check_program node
    if [ $? -ne 0 ]; then
        # downloading node
        download_node
        # extracting node binary and associated components to /usr/local directory
        extract_node
        success_message "node js binary installed successfully"
    else
        success_message "node js already installed"
    fi
}

# install the package by native package manager
function install_by_package_manager() {
    local package_name=$1
    start_message "installing package $package_name"
    check_program $package_name
    if [ $? -ne 0 ]; then
        if [ "$verbose_opt" = 1 ]; then
            if [ "$package_mgr" -eq 1 ]; then
                apt install -y $package_name
            elif [ "$package_mgr" -eq 2 ]; then
                eopkg install -y $package_name
            fi
        else
            if [ "$package_mgr" -eq 1 ]; then
                apt install -y $package_name >/dev/null 2>&1
            elif [ "$package_mgr" -eq 2 ]; then
                eopkg install -y $package_name >/dev/null 2>&1
            fi
        fi
        if [ $? -ne 0 ]; then
            error_message "error installing $package_name"
            return 3
        else
            success_message "successfully installed $package_name"
        fi
    else
        success_message "already installed $package_name"
    fi
}

# install the npm packages gloabally
function install_by_npm() {
    local package_name=$1
    start_message "installing node package $package_name"
    check_program $package_name
    if [ $? -ne 0 ]; then
        if [ "$verbose_opt" = 1 ]; then
            npm i -g $package_name
        else
            npm i -g $package_name >/dev/null 2>&1
        fi

        if [ $? -ne 0 ]; then
            error_message "error installing node package: $package_name"
            return 3
        else
            success_message "successfully installed node package: $package_name"
        fi
    else
        success_message "already installed node package: $package_name"
    fi
}

# install the node extras that are required for compiling the c++ and other functionalitys (global only)
function install_node_extras() {
    start_message "installing node extras"
    install_by_package_manager make
    install_by_package_manager g++
    install_by_package_manager python
    install_by_npm node-gyp
    success_message "done installing node extras"
}

# checking dependencies
check_dependencies

# download the node js tar ball and extact the tar ball to executable path
# this will install the node js
download_and_extract_node

# install the extra depenedencies of node which are used for compiling c++ files
install_node_extras

# notes
# ------
# apt-get install xz-utils
# ------

# ----- end of file -----
