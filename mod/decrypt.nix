# - decrypt: local & remote decryption settings
{
  lib,
  config,
  ...
}: {
  boot.kernelParams = ["ip=dhcp"];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 222;
      shell = "/bin/cryptsetup-askpass";
      hostKeys = ["/etc/secrets/initrd/ssh_host_ed25519_key"];
      authorizedKeys = lib.concatLists (lib.mapAttrsToList (name: user:
        if lib.elem "wheel" user.extraGroups
        then user.openssh.authorizedKeys.keys
        else [])
      config.users.users);
    };
  };
}
