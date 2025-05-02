{
  config,
  pkgs,
  lib,
  ...
}: let
  pull-switch = pkgs.callPackage ../../pkgs/pull-switch.nix {};
in {
  imports = [
    ./hardware-configuration.nix

    ({pkgs, ...}: {
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

      environment.systemPackages = with pkgs; [libraspberrypi raspberrypi-eeprom];
    })

    ../../mods/env.nix
    ../../mods/ssh.nix
    ../../mods/users.nix
    ../../mods/locale.nix
    ../../mods/decrypt.nix

    ../../mods/xandikos.nix
  ];

  # - Nix configuration
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # - Bootloader configuration
  boot.loader = {
    generic-extlinux-compatible.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  # - Services and miscellaneous configuration
  networking.hostName = "nyx";
  networking.domain = "local";

  environment.systemPackages = [pull-switch];

  ## - Reverse proxy configuration
  services.caddy = {
    enable = true;
    email = "postmaster@unw.re";

    virtualHosts.":80, :443" = {
      logFormat = "output discard";
      extraConfig = let
        response = ''
                  ／＞   フ
                  |  _  _|
                ／` ミ＿xノ
               /        |
              /   ヽ    ﾉ
              │    | | |
          ／￣|    | | |
          ( ( ヽ＿_ヽ_)__)
          ＼_) we did not find what you were looking for...
        '';
      in ''
        respond "${response}" 404
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];

  ## - Services configuration
  services.xandikos = {
    enable = true;
    port = 11111;

    caddy.enable = true;
    caddy.hostName = "test.unw.re";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
