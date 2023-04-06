{
  description = "Ado's Dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Secure Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User profile manager based on Nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Links persistent folders into system
    impermanence.url = "github:nix-community/impermanence";

    # Provides module support for specific vendor hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

  };

  outputs = inputs@{ flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ({ withSystem, inputs, ... }:
        let 
          inherit (home-manager.nixosModules) home-manager;
          inherit (inputs.impermanence.nixosModules) impermanence;
          inherit (inputs.nixpkgs.lib) nixosSystem;
        in {
          flake.nixosConfigurations = withSystem "x86_64-linux" ({system, ...}: {
            zoidberg = nixosSystem {
              inherit system;

              modules = [
                impermanence
                ./modules/impermanence.nix
                # inputs.lanzaboote.nixosModules.lanzaboote
                # ./modules/secureboot.nix
                ./systems/shared.nix
                ./systems/zoidberg.nix
                home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.avanderbergh = import ./home;
                }
              ];
            };
          });
        })
      ];
    };
}
