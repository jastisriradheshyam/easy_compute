#!/bin/sh

#sudo cpupower idle-set -d 3
#sleep 3
#sudo cpupower idle-set -d 2
#sleep 3
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
sleep 3
sudo systemctl restart thermald.service
