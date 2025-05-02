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

    ../../mods/git-annex
  ];

  # - Nix configuration
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=flake:nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  # - Secrets configuration
  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets."xandikos/accounts" = {
      owner = config.services.caddy.user;
    };
  };

  # - Services and miscellaneous configuration
  networking.hostName = "nyx";
  networking.domain = "local";

  environment.systemPackages = [pull-switch];

  ## - `caddy`: Reverse proxy/HTTP 1,2,3 server
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

  ## - `xandikos`: CalDAV/CardDAV server
  services.xandikos = {
    enable = true;

    port = 11001;
    extraOptions = [
      "--autocreate"
    ];
  };

  services.caddy.virtualHosts."cal.unw.re".extraConfig = let
    endpoint = "${config.services.xandikos.address}:${builtins.toString config.services.xandikos.port}";
  in ''
    basic_auth * bcrypt "You shall not pass >:(" {
      import "${config.sops.secrets."xandikos/accounts".path}"
    }

    reverse_proxy ${endpoint}
  '';

  ## - `git-annex`: Distributed file synchronization system
  services.git-annex = {
    enable = true;

    annexes."library" = {
      user = "librarian";
      authorizedKeys = config.users.users.technician.openssh.authorizedKeys.keys;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
