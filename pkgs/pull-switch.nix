{
  pkgs,
  lib,
  ...
}: let
  configuration = "/etc/nixos";

  git = lib.getExe pkgs.git;
in
  pkgs.writeShellScriptBin "pull-switch"
  ''
    set -e

    ${git} -C ${configuration} pull --rebase
    sudo nixos-rebuild switch --fast
  ''
