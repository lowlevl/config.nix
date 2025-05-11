{pkgs, ...}: let
  path = "/usr/bin/unix_chkpwd";

  patch = pkgs.writeText "suid-wrapper-path.patch" ''
    It needs the SUID version during runtime, and that can't be in /nix/store/**
    --- a/modules/pam_unix/Makefile.am
    +++ b/modules/pam_unix/Makefile.am
    @@ -21 +21 @@
    -	-DCHKPWD_HELPER=\"$(sbindir)/unix_chkpwd\" \
    +	-DCHKPWD_HELPER=\"${path}\" \
  '';
  overlay = final: prev: {
    linux-pam = prev.linux-pam.overrideAttrs (old: {patches = [patch];});
  };
in {
  nixpkgs.overlays = [overlay];
}
