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

    ./caffeine.nix
    ./nm-applet.nix
    ./blueman-applet.nix
  ];

  xsession.enable = true;
}
