{pkgs, ...}: {
  programs.i3status-rust = {
    enable = true;
    package = pkgs.unstable.i3status-rust;

    bars.bottom = {
      settings = {
        theme = {
          theme = "srcery";

          overrides = {
            alternating_tint_bg = "#0a0a0a";
            alternating_tint_fg = "#0a0a0a";
          };
        };

        icons = {
          icons = "awesome5";

          overrides = {
            bat = [
              "| |"
              "|¼|"
              "|½|"
              "|¾|"
              "|•|"
            ];
            bat_charging = "|^|";
          };
        };
      };

      blocks = [
        {
          block = "music";
          format = " $icon {$combo.str(max_w:20,rot_interval:0.3) $play $next |}";
        }
        {
          block = "sound";
          click = [
            {
              button = "left";
              cmd = "pavucontrol";
            }

          ];
        }
        {
          block = "cpu";
          interval = 1;
          format = " $icon $utilization ";
          format_alt = " $icon $barchart $frequency ";
          info_cpu = 20;
          warning_cpu = 50;
          critical_cpu = 90;
        }
        {
          block = "temperature";
          format = " $icon ~$average ";
          format_alt = " $icon $min~$max ";
        }
        {
          block = "time";
          format = " $icon $timestamp.datetime(f:'%a %d %b %R', l:fr_FR) ";
          interval = 60;
        }
        {
          block = "scratchpad";
          theme_overrides = {
            idle_bg.link = "warning_bg";
            idle_fg.link = "warning_fg";
          };
        }
        {
          block = "battery";
          format = " $icon $percentage ";
        }
      ];
    };
  };
}
