#!/bin/bash

sudo systemctl disable bluetooth
sudo systemctl enable bluetooth
sudo systemctl stop bluetooth
sudo systemctl start bluetooth

rfkill block bluetooth
rfkill unblock bluetooth

sudo rmmod btusb
sudo modprobe btusb
