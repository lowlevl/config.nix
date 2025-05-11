{
  pkgs,
  lib,
  ...
}: {
  services.betterlockscreen = {
    enable = false;
    arguments = [
      "blur"
      "--off 10"
      "--show-layout"
    ];

    inactiveInterval = 15;
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 15;

    # TODO: Change this to betterlockscreen (fix PAM) issues
    lockCmd = "blurlock";
  };
}
