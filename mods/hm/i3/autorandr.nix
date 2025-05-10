{pkgs, lib, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      autorandr = pkgs.writeShellScriptBin "autorandr" "exec ${lib.getExe prev.autorandr} --match-edid \"$@\"";
    })
  ];

  services.autorandr = {
    enable = true;
  };
}
