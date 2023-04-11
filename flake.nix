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

  outputs = inputs@{ self, flake-parts, home-manager, ... }:
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
                  modules = [ ./hosts/zoidberg ];
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
