{nixgl, ...}: {
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [nixgl.overlay];
  nixGL.packages = pkgs.nixgl;

  programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
}
