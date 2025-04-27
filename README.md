# Infra

Repository to store and increment on my IaC, using NixOS.

## Requirements

## The node: Raspberry PI 4

- OS: NixOS
- Case: DeskPi Pro
- Drive: Kingston DC500M 960GB

### Enable the CPU fan at fixed speed

> ⚠️ You need to enable **front USB ports** as described earlier, the CPU fan is hooked up to the front hub.

Create file `/etc/local.d/99-cpufan.start` and make it executable with the following contents:
```
echo 'pwm_080' > /dev/ttyUSB0
```

> ℹ️ You can change the speed by using a different speed percentage prefixed by `pwm_`, in example `pwm_100` means 100% and `pwm_012` means 12%.

Then, enable `/etc/local.d` scripts at startup:
```
$ rc-update add local default
```
