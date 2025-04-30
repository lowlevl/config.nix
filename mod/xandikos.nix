# - xandikos: extend xandikos's service capabilities
{
  config,
  lib,
  ...
}: let
  cfg = config.services.xandikos;
in {
  options.services.xandikos = {
    traefik = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether a Traefik service should be set up to serve Xandikos
        '';
      };

      hostName = lib.mkOption {
        type = lib.types.str;
        description = ''
          Hostname for the service & router configuration
        '';
      };

      middlewares = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Middlewares for the router configuration
        '';
      };

      certResolver = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Certificate resolver for the router configuration
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.traefik.enable) {
    services.traefik.dynamicConfigOptions = {
      http.routers = {
        xandikos = {
          rule = "Host(`${cfg.traefik.hostName}`)";
          service = "xandikos";
          middlewares = cfg.traefik.middlewares;

          tls = lib.mkIf (!builtins.isNull cfg.traefik.certResolver) {
            certResolver = cfg.traefik.certResolver;
          };
        };
      };

      http.services = {
        xandikos = {
          loadBalancer.servers = [
            {url = "http://${cfg.address}:${builtins.toString cfg.port}";}
          ];
        };
      };
    };
  };
}
