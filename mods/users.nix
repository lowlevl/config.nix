# - users: common users and groups on all machines
{pkgs, ...}: {
  security.sudo.wheelNeedsPassword = false;

  users = {
    mutableUsers = false;

    users.technician = {
      isNormalUser = true;
      extraGroups = ["wheel"];

      packages = with pkgs; [
        neovim
        btop
        file
        tree
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIApk7ff1eG79YR6emIzR+iyXchjFlh1HdTK9Uki9YmN2 bee@hive"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEac1v6+SJ9gZ208cyORTeD0U3/HcC5ovyvxJnH797o3 unix@socket"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdppi2v6SFIjXVrOvlPTEn3mqwhamM0b44xhgBM53pF phone:pixel8"
      ];
    };
  };
}
