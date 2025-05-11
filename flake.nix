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

    nixosConfigurations."nyx" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};

      system = "aarch64-linux";
      modules = [
        ./confs/nyx
      ];
    };

    homeConfigurations."bee" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        overlays = [self.overlays."unstable-packages"];
        system = "x86_64-linux";
      };

      modules = [
        ./mods/hm/hm.nix
        ./mods/hm/pam.nix
        ./mods/hm/shell.nix
        ./mods/hm/neovim.nix
        ./mods/hm/i3

        ./homes/bee.nix
      ];

      extraSpecialArgs = {
        inherit inputs;
        username = "bee";
      };
    };
  };
}
