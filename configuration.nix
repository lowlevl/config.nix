{
  config,
  pkgs,
  lib,
  ...
}: let
  sources = import ./sources.nix;

  pull-switch = pkgs.callPackage ./pkgs/pull-switch.nix {};
in {
  imports = [
    ./hardware-configuration.nix

    # - Hardware configuration
    "${sources.nixos-hardware}/raspberry-pi/4"

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

    ./mod/env.nix
    ./mod/ssh.nix
    ./mod/users.nix
    ./mod/locale.nix
    ./mod/decrypt.nix

    ./mod/xandikos.nix
  ];

  # - Bootloader configuration
  boot.loader = {
    generic-extlinux-compatible.enable = false;
    systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
  };

  # - Services and miscellaneous configuration
  networking.hostName = "core";
  networking.domain = "homelab.internal";

  environment.systemPackages = [pull-switch];

  ## - Reverse proxy configuration
  networking.firewall.allowedTCPPorts = [80 443];
  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;

          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;

          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "WARN";
        format = "json";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@unw.re";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };
    };
  };

  ## - Services configuration
  services.xandikos = {
    enable = false;

    port = 11101;

    traefik.enable = true;
    traefik.hostName = "test.unw.re";
    traefik.certResolver = "letsencrypt";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
