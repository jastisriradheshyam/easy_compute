#!/bin/sh

#sudo cpupower idle-set -d 3
#sleep 3
#sudo cpupower idle-set -d 2
#sleep 3
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
sleep 3
echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct
echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost
sudo systemctl stop thermald.service

# References
# https://docs.kernel.org/admin-guide/pm/intel_pstate.html
