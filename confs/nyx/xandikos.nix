## - `xandikos`: CalDAV/CardDAV server
{config, ...}: {
  sops.secrets."xandikos/accounts" = {
    owner = config.services.caddy.user;
  };

  services.xandikos = {
    enable = true;

    port = 11001;
    extraOptions = [
      "--autocreate"
    ];
  };

  services.caddy.virtualHosts."cal.unw.re" = {
    extraConfig = let
      endpoint = "${config.services.xandikos.address}:${builtins.toString config.services.xandikos.port}";
    in ''
      basic_auth * bcrypt "You shall not pass >:(" {
        import "${config.sops.secrets."xandikos/accounts".path}"
      }

      reverse_proxy ${endpoint}
    '';
  };
}
