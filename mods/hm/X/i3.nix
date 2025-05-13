{
  lib,
  pkgs,
  config,
  ...
}: let
  pulseaudio-ctl = lib.getExe pkgs.pulseaudio-ctl;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  rofi = lib.getExe config.programs.rofi.finalPackage;
  rofi-screenshot = lib.getExe pkgs.rofi-screenshot;
  rofi-power-menu = lib.getExe pkgs.rofi-power-menu;
  xkill = lib.getExe pkgs.xorg.xkill;
  xset = lib.getExe pkgs.xorg.xset;

  i3status-rs = lib.getExe config.programs.i3status-rust.package;
  nitrogen = lib.getExe pkgs.nitrogen;
in {
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";
      workspaceAutoBackAndForth = true;

      fonts = {
        names = ["DejaVu Sans Mono"];
        size = 11.0;
      };

      gaps = {
        smartBorders = "on";
        smartGaps = true;

        inner = 14;
        outer = -2;
      };

      keybindings = lib.mkOptionDefault {
        "Print" = "exec ${rofi-screenshot}";

        "XF86AudioMute" = "exec --no-startup-id ${pulseaudio-ctl} mute";
        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pulseaudio-ctl} up";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pulseaudio-ctl} down";
        "XF86MonBrightnessUp" = "exec --no-startup-id ${brightnessctl} set 4%+";
        "XF86MonBrightnessDown" = "exec --no-startup-id ${brightnessctl} set 4%-";

        "${modifier}+p" = "exec --no-startup-id systemctl --user restart autorandr.service";

        "${modifier}+d" = "exec ${rofi} -show drun";
        "${modifier}+Tab" = "exec ${rofi} -show window";
        "${modifier}+Ctrl+x" = "exec --no-startup-id ${xkill}";

        "${modifier}+9" = "exec --no-startup-id ${xset} s activate";
        "${modifier}+0" = "exec ${rofi} -show p -modi p:'${rofi-power-menu}'";
        "${modifier}+Shift+9" = "nop";
        "${modifier}+Shift+10" = "nop";

        "${modifier}+Ctrl+Right" = "workspace next";
        "${modifier}+Ctrl+Left" = "workspace prev";
      };

      assigns = {
        "8" = [
          {class = "Telegram";}
          {class = "Signal";}
        ];
      };

      window = {
        border = 1;
        titlebar = false;

        commands = [
          {
            command = "focus";
            criteria.urgent = "latest";
          }
        ];
      };

      floating = {
        border = window.border;
        titlebar = window.titlebar;

        criteria = [
          {title = "alsamixer";}
          {class = "GParted";}
          {class = "Manjaro Settings Manager";}
        ];
      };

      bars = [
        {
          position = "bottom";
          fonts = fonts;

          statusCommand = ''
            ${i3status-rs} "$HOME/${config.xdg.configFile."i3status-rust/config-bottom.toml".target}"
          '';
          extraConfig = ''
            strip_workspace_numbers yes
            height 24
          '';

          colors = {
            background = "#1c1b19";
          };
        }
      ];

      startup = [
        {
          command = "${nitrogen} --restore";
          notification = false;
        }
      ];
    };
  };
}
