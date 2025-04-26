# - ssh: ssh2 service configuration
{...}: {
  services.openssh = {
    enable = true;

    openFirewall = true;
    startWhenNeeded = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
