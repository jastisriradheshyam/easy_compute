#!/bin/sh
swayidle -w \
      timeout 1 'swaylock -f -c 000000' \
      timeout 1 'swaymsg "output * dpms off"' \
      resume 'swaymsg "output * dpms on"' \
      before-sleep 'swaylock -f -c 000000'
