{
  description = "Ado's Dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    catppuccin = {
      url = "github:ryand56/catppuccin-nix?ref=home-manager-kvantum-fix";
    };

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

    spicetify-nix.url = github:the-argus/spicetify-nix;

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    catppuccin,
    home-manager,
    nixos-hardware,
    spicetify-nix,
    sops-nix,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowCuda = true;
        permittedInsecurePackages = [
          # For loqseq
          "electron-27.3.11"
        ];
      };
      overlays = [
        (import ./pkgs)
        (self: super: {
          utillinux = super.util-linux;
        })
      ];
    };

    nixosModules = [
      ./modules/nixos/global
    ];

    homeModules = rec {
      shared = [
        catppuccin.homeManagerModules.catppuccin
        sops-nix.homeManagerModules.sops
        ./modules/hm
        ./modules/hm/console.nix
        ./modules/hm/git.nix
        ./modules/hm/node.nix
        ./modules/hm/python.nix
        ./modules/hm/sops.nix
      ];
      "avanderbergh@zoidberg" = [./modules/hm/desktop ./modules/hm/desktop/autorandr.nix] ++ shared;
      "avanderbergh@hermes" = [./modules/hm/desktop] ++ shared;
    };

    desktops_1 = ["1" "2" "3" "4" "5"];
    desktops_2 = ["6" "7" "8" "9" "10"];

    hostConfigs = {
      zoidberg = {
        monitor = "eDP-1";
        monitors = {
          "eDP-1" = desktops_1;
          "DP-1-1" = desktops_2;
        };
        wlan-interface = "wlp4s0";
        polybar = {
          font-1-size = "32;20";
          font-2-size = "22;14";
          modules-right = "lr cpu sp memory sp battery sp network rr";
        };
        top-distance = "100px";
      };
      hermes = {
        monitor = "DP-0";
        monitors = {"DP-0" = desktops_1 ++ desktops_2;};

        wlan-interface = "wlp10s0";
        polybar = {
          font-1-size = "32;10";
          font-2-size = "20;6";
          modules-right = "lr cpu sp memory sp network rr";
        };
        top-distance = "60px";
      };
    };

    colors = import ./lib/theme/colors.nix;

    mkExtraSpecialArgs = hostConfig: {inherit pkgs self inputs colors hostConfig spicetify-nix;};
  in {
    nixosConfigurations = {
      zoidberg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit pkgs self inputs colors outputs;};
        modules =
          [
            nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
            ./hosts/zoidberg
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
        specialArgs = {inherit pkgs self inputs colors outputs;};
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/hermes
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
      farnsworth = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit pkgs self inputs colors outputs;};
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-gpu-amd
            ./hosts/farnsworth
          ]
          ++ nixosModules;
      };
    };

    homeConfigurations = {
      "avanderbergh@zoidberg" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkExtraSpecialArgs hostConfigs.zoidberg;
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
