{
  pkgs,
  lib,
  ...
}: let
  path = "/usr/bin/unix_chkpwd";

  overlay = self: super: {
    linux-pam-non-nix = let
      patch = pkgs.writeText "suid-wrapper-path.patch" ''
        It needs the SUID version during runtime, and that can't be in /nix/store/**
        --- a/modules/pam_unix/Makefile.am
        +++ b/modules/pam_unix/Makefile.am
        @@ -21 +21 @@
        -	-DCHKPWD_HELPER=\"$(sbindir)/unix_chkpwd\" \
        +	-DCHKPWD_HELPER=\"${path}\" \
      '';
    in
      super.linux-pam.overrideAttrs (old: {patches = [patch];});

    i3lock = super.i3lock.override {pam = self.linux-pam-non-nix;};
    i3lock-color = super.i3lock-color.override {pam = self.linux-pam-non-nix;};
  };
in {
  nixpkgs.overlays = [overlay];
}
