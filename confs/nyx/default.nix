{
  self,
  nixpkgs,
  sops-nix,
  pkgs,
  lib,
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

    ./fail2ban.nix
    ./caddy.nix
    ./xandikos.nix
    ./git-annex.nix
    ./factorio.nix
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

  # - Enable x86_64 emulation
  boot.binfmt = {
    emulatedSystems = ["x86_64-linux"];
    registrations.x86_64-linux.interpreter = lib.getExe pkgs.box64;
  };

  # - Services and miscellaneous configuration
  networking.hostName = "nyx";
  networking.domain = "local";

  environment.systemPackages = [pull-switch];

  # - Secrets configuration
  sops.defaultSopsFile = ./secrets.yaml;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11"; # Did you read the comment?
}
