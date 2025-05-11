{pkgs, ...}: {
  programs.rofi = {
    enable = true;

    theme = "gruvbox-dark-hard";
  };

  # Fix the "Can't set locale" issue with `rofi`
  home.sessionVariables.LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
}
