#!/bin/bash

mkdir -p ~/.joplin
jopline_data_path=~/workspace/data/jopline

cat >> ~/.local/share/applications/appimagekit-joplin.desktop <<-EOF
[Desktop Entry]
Encoding=UTF-8
Name=Joplin
Comment=Joplin for Desktop
Exec=${HOME}/.joplin/Joplin.AppImage --profile $jopline_data_path/personal %u
Icon=joplin
StartupWMClass=Joplin
Type=Application
Categories=Office;
MimeType=x-scheme-handler/joplin;
X-GNOME-SingleWindow=true // should be removed eventually as it was upstream to be an XDG specification
SingleMainWindow=true
EOF