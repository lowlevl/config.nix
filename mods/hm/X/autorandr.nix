{
  pkgs,
  lib,
  ...
}: {
  services.autorandr = {
    enable = true;
    matchEdid = true;
  };
}
