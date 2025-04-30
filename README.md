# Infra

Repository to store and increment on my IaC, using NixOS.

## Requirements

## The node: Raspberry PI 4

- OS: NixOS
- Case: DeskPi Pro
- Drive: Kingston DC500M 960GB

# Installation quirks

## U-booting into systemd-boot:

Don't forget to copy `armstub8-gic.bin`, `bcm2711-rpi-4-b.dtb`, `config.txt`,
`fixup4*.dat`, `start4*.elf` and `u-boot-rpi4.bin` from the installer to the boot partition.
