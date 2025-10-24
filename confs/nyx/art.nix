## - `art`: A collection of ascii-art domains
{...}: {
  services.caddy.virtualHosts."caw.unw.re" = {
    logFormat = "output discard";
    extraConfig = let
      response = ''
                   ¸¸   /:       *caw*
                  { · >/
             _.-¨_¨_ )O    *caw*
          ,~`  ____.~                       *caw*
        ~`- `¨ //                 *caw*
               ¨¨
      '';
    in ''
      respond "${response}"
    '';
  };
}
