{...}: {
  services.fail2ban = {
    enable = true;
    maxretry = 5;

    bantime = "1h";
    bantime-increment.enable = true;
  };
}
