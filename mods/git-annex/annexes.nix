{cfg}: {
  lib,
  name,
  ...
}: {
  options = {
    user = lib.mkOption {
      type = lib.types.passwdEntry lib.types.str;
      description = ''
        The name of the user account to be created for this annex.
      '';
    };

    path = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.store}/${name}.git";
      description = ''
        The full path of the annex on the filesystem.
      '';
    };

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [];
      description = ''
        A list of verbatim OpenSSH public keys that should be added to the
        user's authorized keys.
      '';
    };
  };
}
