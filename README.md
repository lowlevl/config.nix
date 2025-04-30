# Infra

Repository to store and increment on my IaC, using NixOS.

## Todos

- Restore the dynamic fan PWM curve.
- Install a reverse proxy optional authentication.
- Install `xandikos` behind authentication.
- Set up a `git-annex`.

## The node: Raspberry Pi 4

- OS: NixOS latest
- Case: DeskPi Pro
- Drive: Kingston DC500M 960GB

# Installation quirks

## U-booting into `systemd-boot`:

To be able to use initrd secrets and a modern bootloader, we're setting up `systemd-boot`,
however since the Pi firmware isn't EFI-capable, we have to use U-boot to jump into `systemd-boot`.

To do this, we have to _manually_ copy `armstub8-gic.bin`, `bcm2711-rpi-4-b.dtb`, `config.txt`,
`fixup4*.dat`, `start4*.elf` and `u-boot-rpi4.bin` from the installer to the `/boot` partition.
