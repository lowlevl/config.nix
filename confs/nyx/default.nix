{
  self,
  nixpkgs,
  sops-nix,
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

    ./caddy.nix
    ./xandikos.nix
    ./git-annex.nix
  ];

  # - Nix configuration
  nixpkgs.overlays = [self.overlays."old-packages"];
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    registry.nixpkgs.flake = nixpkgs;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  # - Secrets configuration
  sops.defaultSopsFile = ./secrets.yaml;

  # - Services and miscellaneous configuration
  networking.hostName = "nyx";
  networking.domain = "local";

  environment.systemPackages = [pull-switch];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
