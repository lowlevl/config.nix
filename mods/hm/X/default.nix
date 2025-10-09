# hm/X: settings for X.org, i3/sway and extensions
{...}: {
  imports = [
    ./i3.nix
    ./bar.nix
    ./lock.nix
    ./rofi.nix

    ./dunst.nix
    ./picom.nix
    ./autorandr.nix

    ./kitty.nix
  ];

  xsession.enable = true;

  home.keyboard = {
    layout = "us,fr";
    options = ["grp:win_space_toggle" "compose:rctrl"];
  };

  services = {
    caffeine.enable = true;
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
