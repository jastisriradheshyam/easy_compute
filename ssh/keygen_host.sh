#!/bin/bash

## Author : Jasti Sri Radhe Shyam (https://jastisriradheshyam.github.io)

function printHelp() {
    cat <<EOL
Usage:
    generic_keygen_host.sh [Flags]

    Flags:
        -h   print help
        --host set the host
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
    --host)
        host="$2"
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

function check() {
    # https://stackoverflow.com/a/13864829/5516994
    if [ -z ${host+x} ]; then
        echo "Host is not set"
        exit 1
    fi
}

function bootstap() {
    mkdir -p ~/.ssh ~/Documents/ssh_public &>/dev/null && chmod 700 ~/.ssh
    rm -f ~/.ssh/*$host.pem
}

function generate() {
    ssh-keygen -t rsa -N "" -b 4096 -f ~/.ssh/$host.pem >/dev/null
    chmod 400 ~/.ssh/$host.pem
}

function move_public_key() {
    yes | mv ~/.ssh/$host.pem.pub ~/Documents/ssh_public/$host.public_key.txt
}

function set_config() {
    local text="\n## $host ##\nHost $host\n IdentityFile ~/.ssh/$host.pem\n"
    echo -e "$text" >>~/.ssh/config
    chmod 600 ~/.ssh/config
}

function show_public_key() {
    echo -e "\e[32m[+]\e[39m Public key Content Is:\n\e[90m"
    cat ~/Documents/ssh_public/$host.public_key.txt
}

check
bootstap
generate
move_public_key
set_config
show_public_key

# ----------------------------------------------------------------------------------- #
# References:
# [1] : https://www.ssh.com/ssh/keygen
# ----------------------------------------------------------------------------------- #
# --EOF--
