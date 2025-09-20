## - `factorio`: A game server
{
  nixpkgs-unstable,
  lib,
  ...
}: let
  pkgsx86_64 = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in {
  services.factorio = {
    enable = true;
    openFirewall = true;

    package = pkgsx86_64.factorio-headless;

    lan = true;
    nonBlockingSaving = true;

    game-name = "A better world";
    description = "A game where we try to engineer a better world out of this one";

    allowedPlayers = ["mayabeille" "Reliant_Gesture"];
    admins = ["mayabeille"];
  };

  # `box64`'s JIT compilation needs executable sections
  systemd.services.factorio.serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;
}
