# - git-annex: module to create and configuration annexes
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.git-annex;

  mkUser = name: annex: {
    "${annex.user}" = {
      description = "User for git-annex at '${annex.path}'.";
      isSystemUser = true;

      packages = [cfg.git];
      shell = lib.getExe' cfg.package "git-annex-shell";
      group = annex.user;
      home = cfg.store;

      openssh.authorizedKeys.keys =
        builtins.map
        (key: ''environment="GIT_ANNEX_SHELL_LIMITED=true",environment="GIT_ANNEX_SHELL_DIRECTORY=${annex.path}",restrict ${key}'')
        annex.authorizedKeys;
    };
  };
in {
  options.services.git-annex = {
    enable = lib.mkEnableOption "git-annex service";

    package = lib.mkPackageOption pkgs "git-annex" {};
    git = lib.mkPackageOption pkgs "git" {};

    user = lib.mkOption {
      description = ''
        User account for the 'git-annex' service.
      '';
      default = "git-annex";
      type = lib.types.str;
    };

    group = lib.mkOption {
      description = ''
        Group for the 'git-annex' service.
      '';
      default = cfg.user;
      type = lib.types.str;
    };

    store = lib.mkOption {
      description = ''
        Where annexes are stored in the filesystem.
      '';
      default = "/var/lib/annexes";
      type = lib.types.str;
    };

    annexes = lib.mkOption {
      description = ''
        Annexes to create and configure.
      '';
      default = {};
      type = lib.types.attrsOf (lib.types.submodule (import ./annexes.nix {inherit cfg;}));
    };
  };

  config = lib.mkIf cfg.enable {
    users.users =
      (lib.concatMapAttrs mkUser cfg.annexes)
      // {
        "${cfg.user}" = {
          isSystemUser = true;
          group = cfg.group;
        };
      };
    users.groups =
      (lib.concatMapAttrs (name: annex: {"${annex.user}" = {};}) cfg.annexes)
      // {"${cfg.group}" = {};};

    # note: to be replaced by `lib.concatMapAttrsStringsSep`
    environment.etc."annexes.conf".text =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList (name: annex: "${annex.user}:${annex.path}") cfg.annexes);

    systemd.services."git-annex" = {
      wantedBy = ["multi-user.target"];
      restartTriggers = [config.environment.etc."annexes.conf".source];

      script = ''
        ${lib.getExe cfg.git} config set --file "${cfg.store}/.gitconfig" safe.directory "${cfg.store}/*"

        while IFS=: read -r owner annex || [ -n "$owner" ]
        do
          echo -n "Checking '$annex' for initialization.. "

          if [ -d "$annex" ]
          then
            echo "skipping."
            continue
          fi

          echo "needs init."

          ${lib.getExe cfg.git} init --bare "$annex"
          chgrp --recursive "$owner" "$annex"
          chmod --recursive g+u "$annex"
          chmod o= "$annex"
        done < /etc/annexes.conf
      '';

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = lib.mapAttrsToList (name: annex: annex.user) cfg.annexes;

        StateDirectory =
          lib.mkIf
          (lib.hasPrefix "/var/lib/" cfg.store)
          (lib.removePrefix "/var/lib/" cfg.store);

        ProtectSystem = "full";
        PrivateDevices = true;
        ProtectHome = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };
}
