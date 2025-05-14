{
  self,
  nixpkgs,
  sops-nix,
  config,
  pkgs,
  ...
}: let
  pull-switch = pkgs.callPackage ../../pkgs/pull-switch.nix {};
in {
  imports = with self.nixosModules; [
    sops-nix.nixosModules.sops

    ./hardware-configuration.nix
    ./raspberry-pi-4.nix

    env
    ssh
    users
    locale
    decrypt
    git-annex
  ];

  # - Nix configuration
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    registry.nixpkgs.flake = nixpkgs;

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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
