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

    # Window Manager
    hyprland.url = "github:hyprwm/Hyprland";

    # Links persistent folders into system
    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = inputs@{ self, flake-parts, home-manager, hyprland, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ({ withSystem, inputs, ... }:
          let inherit (inputs.nixpkgs.lib) nixosSystem;
          in {
            flake.nixosConfigurations = withSystem "x86_64-linux"
              ({ system, ... }: {
                zoidberg = nixosSystem {
                  inherit system;
                  specialArgs = { inherit inputs; };

                  modules = [
                    ./systems
                    ./systems/zoidberg.nix
                    home-manager.nixosModules.home-manager
                    {
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;
                      home-manager.users.avanderbergh = {
                        imports =
                          [ hyprland.homeManagerModules.default ./home ];
                      };
                    }
                  ];
                };
              });
          })
      ];

      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
