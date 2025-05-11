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
  ];

  xsession.enable = true;

  services = {
    caffeine.enable = true;
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };
}
