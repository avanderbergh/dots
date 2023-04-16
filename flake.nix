{
  description = "Ado's Dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    nixosModules = [./modules/nixos/global];

    homeModules = rec {
      shared = [./modules/hm];
      "avanderbergh@zoidberg" = [./modules/hm/desktop] ++ shared;
    };
  in {
    imports = [./lib];

    nixosConfigurations = {
      zoidberg = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs colors;};
        modules =
          [
            inputs.nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
            ./hosts/zoidberg.nix
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = {inherit self inputs colors;};
                users.avanderbergh.imports = homeModules."avanderbergh@zoidberg";
              };
            }
          ]
          ++ nixosModules;
      };
    };

    homeConfigurations = {
      "avanderbergh@zoidberg" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs colors;};
        modules = homeModules."avanderbergh@zoidberg";
      };
    };
  };
}
