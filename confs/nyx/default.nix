{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  pull-switch = pkgs.callPackage ../../pkgs/pull-switch.nix {};
in {
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./hardware-configuration.nix
    ./raspberry-pi-4.nix

    ../../mods/env.nix
    ../../mods/ssh.nix
    ../../mods/users.nix
    ../../mods/locale.nix
    ../../mods/decrypt.nix
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

  # - Secrets configuration
  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets."xandikos/users" = {
       owner = config.services.caddy.user;
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
  };
  services.caddy.virtualHosts."test.unw.re".extraConfig = ''
    basic_auth * bcrypt "You shall not pass >:(" {
      import "${config.sops.secrets."xandikos/users".path}"
    }

    reverse_proxy ${config.services.xandikos.address}:${builtins.toString config.services.xandikos.port}
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
