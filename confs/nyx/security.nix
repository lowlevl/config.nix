{...}: {
  networking.firewall.enable = true;

  services.endlessh = {
    enable = true;
    port = 22;

    openFirewall = true;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;

    bantime = "1h";
    bantime-increment.enable = true;

    jails = {
      sshd.settings = {
        backend = "systemd";
        mode = "aggressive";
      };
    };
  };
}
