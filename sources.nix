{
  # master@2025-04-24
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/f7bee55a5e551bd8e7b5b82c9bc559bc50d868d1.tar.gz";
    sha256 = "1311w59q8rcjnj8415z1pjlz5c1lsfrgxz9wg78fgc6mlfys6hbd";
  };

  # master@2025-04-24
  sops-nix =
    builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/5e3e92b16d6fdf9923425a8d4df7496b2434f39c.tar.gz";
      sha256 = "";
    }
    + "/modules/sops";
}
