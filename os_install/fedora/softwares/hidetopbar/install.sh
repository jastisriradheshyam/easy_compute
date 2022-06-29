#!/bin/sh

mkdir -p ~/.local/share/gnome-shell/extensions/
cd ~/.local/share/gnome-shell/extensions/
git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca
cd hidetopbar@mathieu.bidon.ca
make
cd ..
gnome-extensions enable hidetopbar@mathieu.bidon.ca
gnome-shell --replace &
