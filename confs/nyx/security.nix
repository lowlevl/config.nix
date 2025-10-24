## - `security`: All the security settings for the machine
{...}: {
  networking.firewall.enable = true;
  networking.nftables.enable = true;

  services.endlessh = {
    enable = true;
    port = 22;

    openFirewall = true;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;

    ignoreIP = [
      "10.0.0.0/8"
    ];

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
