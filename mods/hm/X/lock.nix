{...}: {
  services.betterlockscreen = {
    enable = true;
    arguments = [
      "blur"
      "--off 30"
      "--show-layout"
      "--"
      "--"
      "--nofork"
      "--pass-volume-keys"
      "--ignore-empty-password"
    ];

    inactiveInterval = 15;
  };

  services.screen-locker = {
    xss-lock.extraOptions = ["--transfer-sleep-lock"];
  };
}
