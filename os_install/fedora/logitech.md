
https://forum.manjaro.org/t/disabled-every-device-in-acpi-wakeup-and-my-logi-bolt-receiver-still-wakes-computer-immediately-after-suspend/138355/2

- `lsusb | grep Logitech`
- `/etc/udev/rules.d/90-usb-wakeup.rules`

```
# Disable Logitech waking
ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled"
```
