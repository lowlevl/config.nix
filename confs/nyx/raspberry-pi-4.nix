# - raspberry-pi-4: configuration & tweaks for the hardware
{
  nixos-hardware,
  pkgs,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # - Hardware configuration
  hardware = {
    deviceTree.enable = true;
    deviceTree.name = "broadcom/bcm2711-rpi-4-b.dtb";

    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    raspberry-pi."4".dwc2 = {
      enable = true;
      dr_mode = "host";
    };
  };

  # `initrd` networking modules
  boot.initrd.availableKernelModules = ["smsc95xx" "usbnet"];

  # - Bootloader configuration
  boot.loader = {
    generic-extlinux-compatible.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  environment.systemPackages = with pkgs; [libraspberrypi raspberrypi-eeprom];
}
