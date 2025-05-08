{
  lib,
  pkgs,
  ...
}: {
  xsession.windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "Mod4";
      workspaceAutoBackAndForth = true;

      fonts = {
        names = ["DejaVu Sans Mono" "Font Awesome 6 Free 11"];
        size = 11.0;
      };

      gaps = {
        smartBorders = "on";
        smartGaps = true;

        inner = 14;
        outer = -2;
      };

      keybindings = let
        amixer = lib.getExe' pkgs.alsa-utils "amixer";
        brightnessctl = lib.getExe pkgs.brightnessctl;
        rofi = lib.getExe pkgs.brightnessctl;
        rofi-screenshot = lib.getExe pkgs.rofi-screenshot;
        rofi-power-menu = lib.getExe pkgs.rofi-power-menu;
        xkill = lib.getExe pkgs.xorg.xkill;
      in
        lib.mkOptionDefault {
          "Print" = "exec ${rofi-screenshot}";

          "XF86AudioMute" = "exec --no-startup-id ${amixer} set Master toggle";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${amixer} set Master 4%-";
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${amixer} set Master 4%+";
          "XF86MonBrightnessDown" = "exec --no-startup-id ${brightnessctl} set 4%-";
          "XF86MonBrightnessUp" = "exec --no-startup-id ${brightnessctl} set 4%+";

          "${config.modifier}+d" = "exec ${rofi} -show drun";
          "${config.modifier}+Tab" = "exec ${rofi} -show window";
          "${config.modifier}+Ctrl+x" = "exec --no-startup-id ${xkill}";

          "${config.modifier}+9" = "exec --no-startup-id blurlock";
          "${config.modifier}+10" = "exec ${rofi-power-menu}";
          "${config.modifier}+Shift+9" = "nop";
          "${config.modifier}+Shift+10" = "nop";

          "${config.modifier}+Ctrl+Right" = "workspace next";
          "${config.modifier}+Ctrl+Left" = "workspace prev";
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
        border = config.window.border;
        titlebar = config.window.titlebar;

        criteria = [
          {title = "alsamixer";}
          {class = "GParted";}
          {class = "Manjaro Settings Manager";}
        ];
      };

      startup = [
      ];
    };
  };
}
