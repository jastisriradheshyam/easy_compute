#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo ${SCRIPT_DIR}/install_ansible.sh
sudo ${SCRIPT_DIR}/ansible_sudo.sh sudo ansible
sudo ${SCRIPT_DIR}/ansible_sudo.sh sudo $(whoami) 
