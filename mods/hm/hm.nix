# - hm/hm: common home-manager settings
{
  config,
  username,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/home/${config.home.username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
