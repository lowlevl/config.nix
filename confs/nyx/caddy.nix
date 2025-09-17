## - `caddy`: Reverse proxy/HTTP 1,2,3 server
{pkgs, ...}: {
  services.caddy = {
    enable = true;
    package = pkgs.old.caddy;

    email = "postmaster@unw.re";

    virtualHosts.":80, :443" = {
      logFormat = "output discard";
      extraConfig = let
        response = ''
                  ／＞   フ
                  |  _  _|
                ／` ミ＿xノ
               /        |
              /   ヽ    ﾉ
              │    | | |
          ／￣|    | | |
          ( ( ヽ＿_ヽ_)__)
          ＼_) we did not find what you were looking for...
        '';
      in ''
        respond "${response}" 404
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
