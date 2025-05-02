{
  description = "Repository to store and increment on my IaC, using NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};

      system = "aarch64-linux";
      modules = [./confs/nyx];
    };
  };
}
