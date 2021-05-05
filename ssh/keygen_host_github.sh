#!/bin/bash

## Author : Jasti Sri Radhe Shyam (https://jastisriradheshyam.github.io)

echo -e "\e[34m[/]\e[39m Generating SSH Key For Github..."
mkdir ~/.ssh ~/Documents &> /dev/null && chmod 700 ~/.ssh
rm -f ~/.ssh/*github.pem
ssh-keygen -t rsa -N "" -b 4096 -f ~/.ssh/github.pem > /dev/null
yes | mv ~/.ssh/github.pem.pub ~/Documents/ssh_public/github.public_key.txt
chmod 400 ~/.ssh/github.pem
text="\n## Github ##\nHost github.com\n IdentityFile ~/.ssh/github.pem\n"
echo -e "$text" >> ~/.ssh/config
chmod 600 ~/.ssh/config
echo -e "\e[34m[/]\e[39m Generated Public Key Saved To: [\e[35m ~/Documents/github.public_key.txt \e[39m]"
echo -e "\e[32m[+]\e[39m Public key Content Is:\n\e[40m\e[34m"
# directly using cat caused a new line after the echo and background color leaked through the echo
local public_key=$(cat ~/Documents/ssh_public/github.public_key.txt)
echo -e "${public_key}\e[0m\n"
echo -e "\n\e[32m[+]\e[39m Paste This Public Key Content To: [\e[36m https://github.com/settings/keys \e[39m]"

# ----------------------------------------------------------------------------------- #
# References:
# [1] : https://www.ssh.com/ssh/keygen
# ----------------------------------------------------------------------------------- #
# --EOF--
