#!/bin/bash

curl -OL $(curl -s 'https://data.services.jetbrains.com/products/releases?code=IIU%2CIIC&latest=true&type=release&build=' | jq -r '.IIC[0].downloads.linux.link')

tar -zxvf ideaIC-*.tar.gz
mkdir -p /opt/software_installs/idea
mv idea-*/* /opt/software_installs/idea
sudo ln -sf /opt/software_installs/idea/bin/idea.sh /bin/intellijidea-ce


cat > /usr/share/applications/intellij-ce.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community Edition
Icon=/opt/software_installs/idea/bin/idea.svg
Exec="/opt/software_installs/idea/bin/idea.sh" %f
Comment=Capable and Ergonomic IDE for JVM
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea-ce
StartupNotify=true
EOF
