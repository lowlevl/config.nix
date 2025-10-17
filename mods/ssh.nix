# - ssh: ssh2 service configuration
{...}: {
  services.openssh = {
    enable = true;

    ports = [223];
    openFirewall = true;
    # startWhenNeeded = true; # break fail2ban

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
