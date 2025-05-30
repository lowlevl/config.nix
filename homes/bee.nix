{
  self,
  pkgs,
  ...
}: {
  imports = with self.homeModules; [
    hm
    pam
    shell
    neovim
    nixgl
    X
  ];

  # Authentication quirks with PAM
  home.pam = {
    chkpwdPath = "/usr/bin/unix_chkpwd";
    overridePackages = ["i3lock-color"];
  };

  # Enable `git-annex assistant` on startup and append it the i3status config
  home.packages = [pkgs.git-annex];
  xsession.windowManager.i3.config.startup = [
    {
      command = "git annex assistant --autostart --notify-start --notify-finish";
      notification = false;
    }
  ];
  programs.i3status-rust.bars.bottom.blocks = [
    {
      block = "custom";
      persistent = true;
      command = "tail -f ~/Library/.git/annex/daemon.log";
      format = "  $text.pango-str() ";
    }
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11"; # Did you read the comment?
}
