{
  description = "Repository to store and increment on my IaC, using NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    overlays."unstable-packages" = final: prev: {
      unstable = import inputs.nixpkgs-unstable {system = final.system;};
    };

    nixosModules = {
      env = ./mods/env.nix;
      ssh = ./mods/ssh.nix;
      users = ./mods/users.nix;
      locale = ./mods/locale.nix;
      decrypt = ./mods/decrypt.nix;
      git-annex = ./mods/git-annex;
    };

    nixosConfigurations."nyx" = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit (inputs) self nixpkgs sops-nix nixos-hardware;
      };

      system = "aarch64-linux";
      modules = [./confs/nyx];
    };

    homeModules = {
      X = ./mods/hm/X;
      hm = ./mods/hm/hm.nix;
      pam = ./mods/hm/pam.nix;
      shell = ./mods/hm/shell.nix;
      neovim = import ./mods/hm/neovim.nix {inherit (inputs) nixvim;};
    };

    homeConfigurations."bee" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit (inputs) self;

        username = "bee";
      };
      pkgs = import nixpkgs {
        overlays = [self.overlays."unstable-packages"];
        system = "x86_64-linux";
      };

      modules = [./homes/bee.nix];
    };
  };
}
