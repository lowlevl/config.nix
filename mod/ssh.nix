# - ssh: ssh2 service configuration
{...}: {
  services.openssh = {
    enable = true;

    ports = [223];
    openFirewall = true;
    startWhenNeeded = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
