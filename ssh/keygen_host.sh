#!/bin/bash

## Author : Jasti Sri Radhe Shyam (https://jastisriradheshyam.github.io)

function printHelp() {
    cat <<EOL
Usage:
    generic_keygen_host.sh [Flags]

    Flags:
        -h   print help
        --host set the host; usage: --host DOMAIN_NAME
        --soff disable the strict host key checking for this domain
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
    --soff)
        soff="true"
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

function generate_public_key_path() {
    public_key_path=~/Documents/ssh_public/$host.public_key.txt
}

function move_public_key() {
    yes | mv ~/.ssh/$host.pem.pub $public_key_path
}

function set_config() {
    local text="\n## $host ##\nHost $host\n IdentityFile ~/.ssh/$host.pem\n"
    if [ -n ${soff+x} ]; then
        text="$text StrictHostKeyChecking No\n"
    fi
    echo -e "$text" >>~/.ssh/config
    chmod 600 ~/.ssh/config
}

function show_public_key() {
    echo -e "\e[32m[+]\e[39m Public key file path: $public_key_path\n"
    echo -e "\e[32m[+]\e[39m Public key content Is:\n\e[40m\e[34m"
    # directly using cat caused a new line after the echo and background color leaked through the echo
    local public_key=$(cat "$public_key_path")
    echo -e "${public_key}\e[0m\n"
}

check
bootstap
generate
generate_public_key_path
move_public_key
set_config
show_public_key

# ----------------------------------------------------------------------------------- #
# References:
# [1] : https://www.ssh.com/ssh/keygen
# ----------------------------------------------------------------------------------- #
# --EOF--
