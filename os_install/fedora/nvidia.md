- `sudo cp /usr/share/X11/xorg.conf.d/nvidia.conf /etc/X11/xorg.conf.d/nvidia.conf`
- `akmodsbuild /usr/src/akmods/nvidia-kmod.latest`
- `sudo rpm -i --force kmod-nvidia-5.18.6-200.fc36.x86_64-510.68.02-2.fc36.x86_64.rpm`



## NVIDIA

- ` sudo dnf remove xorg-x11-drv-nvidia-cuda`
- `sudo dnf remove nvidia-modprobe`
- `sudo dnf remove akmod-nvidia`
- `sudo dnf remove xorg-x11-drv-nvidia`
- `sudo dnf install akmod-nvidia`
- And restart


## Sleep to wakeup -> slow

- `sudo systemctl restart thermald.service`
- https://askubuntu.com/questions/1137739/noticeable-performance-drop-after-suspend-on-19-04
