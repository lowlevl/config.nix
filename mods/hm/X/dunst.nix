{...}: {
  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = 320;
        offset = "32x48";

        follow = "mouse";
        origin = "top-right";
        alignment = "left";

        transparency = 4;

        corner_radius = 4;
        frame_color = "#161b22";
        frame_width = 1;
      };

      urgency_normal.background = "#37474f";
      urgency_critical.background = "#b04027";
    };
  };
}
