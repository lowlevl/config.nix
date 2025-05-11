{
  pkgs,
  lib,
  ...
}: {
  services.betterlockscreen = {
    enable = true;
    arguments = [
      "blur"
      "--off 30"
      "--show-layout"
      # "--"
      # "--ignore-empty-password"
      # "--pass-volume-keys"
    ];

    inactiveInterval = 15;
  };
}
