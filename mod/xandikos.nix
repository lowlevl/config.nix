# - xandikos: extend xandikos's service capabilities
{
  config,
  lib,
  ...
}: let
  cfg = config.services.xandikos;
in {
  options.services.xandikos = {
    caddy = {
      enable = lib.mkEnableOption "Caddy virtualHost for Xandikos Cal/CardDAV service";

      hostName = lib.mkOption {
        type = lib.types.str;
        description = ''
          Hostname for the Caddy virtualHost
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.caddy.enable) {
    services.caddy.virtualHosts."${cfg.caddy.hostName}".extraConfig = ''
      reverse_proxy ${cfg.address}:${builtins.toString cfg.port}
    '';
  };
}
