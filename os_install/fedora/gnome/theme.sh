#!/bin/bash

THEME_TAR_PATH=$1
THEME_NAME=$2
mkdir -p ~/themes
tar -xf ${THEME_TAR_PATH} ~/themes
exit 0
gsettings set org.gnome.desktop.interface gtk-theme ${THEME_NAME}
