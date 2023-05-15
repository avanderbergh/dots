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
    nixos-hardware,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [(import ./pkgs)];
    };

    nixosModules = [./modules/nixos/global];

    homeModules = rec {
      shared = [./modules/hm ./modules/hm/console.nix ./modules/hm/python.nix];
      "avanderbergh@zoidberg" = [./modules/hm/desktop] ++ shared;
      "avanderbergh@hermes" = [./modules/hm/desktop] ++ shared;
    };

    hostConfigs = {
      zoidberg = {
        monitor = "eDP-1";
        wlan-interface = "wlp4s0";
        polybar = {
          font-1-size = "32;20";
          font-2-size = "22;14";
          modules-right = "lr cpu sp memory sp battery sp network rr";
        };
      };
      hermes = {
        monitor = "DP-0";
        wlan-interface = "wlp10s0";
        polybar = {
          font-1-size = "32;10";
          font-2-size = "20;6";
          modules-right = "lr cpu sp memory sp network rr";
        };
      };
    };

    colors = import ./lib/theme/colors.nix;

    mkExtraSpecialArgs = hostConfig: {inherit pkgs self inputs colors hostConfig;};
  in {
    nixosConfigurations = {
      zoidberg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit pkgs self inputs colors;};
        modules =
          [
            nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
            ./hosts/zoidberg.nix
            {
              home-manager = {
                extraSpecialArgs = mkExtraSpecialArgs hostConfigs.zoidberg;
                useUserPackages = true;
                useGlobalPkgs = true;
                users.avanderbergh.imports = homeModules."avanderbergh@zoidberg";
              };
            }
          ]
          ++ nixosModules;
      };
      hermes = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit pkgs self inputs colors;};
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/hermes.nix
            {
              home-manager = {
                extraSpecialArgs = mkExtraSpecialArgs hostConfigs.hermes;
                useUserPackages = true;
                useGlobalPkgs = true;
                users.avanderbergh.imports = homeModules."avanderbergh@hermes";
              };
            }
          ]
          ++ nixosModules;
      };
    };

    homeConfigurations = {
      "avanderbergh@zoidberg" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = hostConfigs.zoidberg;
        modules = homeModules."avanderbergh@zoidberg";
      };
      "avanderbergh@hermes" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkExtraSpecialArgs hostConfigs.hermes;
        modules = homeModules."avanderbergh@hermes";
      };
    };
  };
}
