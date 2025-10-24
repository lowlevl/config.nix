## - `annexes`: File synchronization system
{config, ...}: {
  services.git-annex = {
    enable = true;

    annexes."library" = {
      user = "librarian";
      authorizedKeys = config.users.users.technician.openssh.authorizedKeys.keys;
    };
  };
}
