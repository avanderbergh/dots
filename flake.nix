{
  description = "Ado's Dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    home-manager,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./lib

        ({
          colors,
          withSystem,
          ...
        }: let
          nixosModules = [./modules/nixos/global];
          homeModules = rec {
            shared = [./modules/hm];
            "avanderbergh@zoidberg" = [./modules/hm/desktop] ++ shared;
          };
        in {
          flake = {
            nixosConfigurations = withSystem "x86_64-linux" ({system, ...}: {
              zoidberg = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = {inherit inputs colors;};
                modules =
                  [
                    inputs.nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
                    ./hosts/zoidberg.nix
                    {
                      home-manager = {
                        useUserPackages = true;
                        useGlobalPkgs = true;
                        extraSpecialArgs = {inherit inputs colors;};
                        users.avanderbergh.imports = homeModules."avanderbergh@zoidberg";
                      };
                    }
                  ]
                  ++ nixosModules;
              };
            });

            homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...}: {
              "avanderbergh@zoidberg" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = {inherit inputs colors;};
                modules = homeModules."avanderbergh@zoidberg";
              };
            });
          };
        })
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args = {
          pkgs = import self.inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
    };
}
