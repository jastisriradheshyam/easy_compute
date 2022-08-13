#!/bin/bash

latest_version=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.tag_name' | tr -d 'v') 
file_name=hugo_${latest_version}_Linux-64bit.tar.gz
install_dir_path=/opt/software_installs/hugo
curl -OL https://github.com/gohugoio/hugo/releases/download/v${latest_version}/${file_name}
mkdir -p ${install_dir_path}
tar -xf ${file_name} --directory ${install_dir_path}

ln -sf ${install_dir_path}/hugo /bin/hugo
