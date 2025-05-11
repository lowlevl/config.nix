{
  pkgs,
  lib,
  ...
}: let
  overlay = self: super: {
    autorandr = pkgs.writeShellScriptBin "autorandr" "exec ${lib.getExe super.autorandr} --match-edid \"$@\"";
  };
in {
  nixpkgs.overlays = [overlay];

  services.autorandr = {
    enable = true;
  };
}
