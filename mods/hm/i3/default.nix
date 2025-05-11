# hm/i3: settings for i3/sway and extensions
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
}
