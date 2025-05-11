# hm/X: settings for X.org, i3/sway and extensions
{...}: {
  imports = [
    ./i3.nix
    ./bar.nix
    ./lock.nix
    ./rofi.nix
    ./dunst.nix
    ./picom.nix
    ./caffeine.nix
    ./autorandr.nix
  ];

  xsession.enable = true;
}
