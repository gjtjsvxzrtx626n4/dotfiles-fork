{
  description = "Ubuntu system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager }:
  {
    nixosConfigurations."ubuntu-system" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./ubuntu.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.server = import ./home.nix;
        }
      ];
    };
  };
}