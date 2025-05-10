{pkgs, lib, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      autorandr = pkgs.writeShellScriptBin "autorandr" "${lib.getExe prev.autorandr} --match-edid \"$@\"";
    })
  ];

  services.autorandr = {
    enable = true;
  };
}
