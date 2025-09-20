{
  description = "Ado's Dots";

  inputs = {
    # Core Nixpkgs channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # NixOS modules and overlays
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
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "http://hermes:5000"
    ];

    extra-trusted-public-keys = [
      "hermes:ctaxZAzCtUCIsQCwrws97n2o81DIPM9c1iXUO3H59U8="
    ];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-master,
    home-manager,
    nixos-hardware,
    sops-nix,
    stylix,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";

    nixosSystemArgs = {
      inherit system;
      config = {
        allowUnfree = true;
        allowCuda = true;
      };
      overlays = [
        (import ./pkgs)
      ];
    };

    mkPkgs = nixpkgsSource: import nixpkgsSource nixosSystemArgs;
    pkgs = mkPkgs nixpkgs;
    pkgs-stable = mkPkgs nixpkgs-stable;
    pkgs-master = mkPkgs nixpkgs-master;

    nixosModules = [
      ./modules/nixos/global
    ];

    homeModules = let
      shared = [
        sops-nix.homeManagerModules.sops
        ./modules/hm
        ./modules/hm/console.nix
        ./modules/hm/git.nix
        ./modules/hm/node.nix
        ./modules/hm/python.nix
        ./modules/hm/sops.nix
        ./modules/hm/ssh.nix
      ];
      mkHomeModules = extra: extra ++ shared;
    in {
      inherit shared;
      "avanderbergh@zoidberg" = mkHomeModules [./modules/hm/desktop ./modules/hm/desktop/autorandr.nix];
      "avanderbergh@hermes" = mkHomeModules [./modules/hm/desktop];
    };

    desktops = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];

    hostConfigs = {
      zoidberg = {
        monitors = {
          "eDP-1-1" = desktops;
        };
      };
      hermes = {
        monitors = {
          "DP-0" = desktops;
        };
      };
    };

    colors = import ./lib/theme/colors.nix;

    mkExtraSpecialArgs = hostConfig: {
      inherit self inputs colors hostConfig pkgs pkgs-stable pkgs-master;
    };

    specialArgs = {
      inherit pkgs-stable pkgs-master self inputs colors outputs;
    };

    mkHostModule = hostName: {
      nixpkgs = nixosSystemArgs;
      home-manager = {
        extraSpecialArgs = mkExtraSpecialArgs hostConfigs.${hostName};
        useUserPackages = true;
        backupFileExtension = "backup";
        users.avanderbergh.imports = homeModules."avanderbergh@${hostName}";
      };
    };

    mkHomeConfig = hostName:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkExtraSpecialArgs hostConfigs.${hostName};
        modules = homeModules."avanderbergh@${hostName}";
      };
  in {
    nixosConfigurations = {
      zoidberg = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
            ./hosts/zoidberg
            (mkHostModule "zoidberg")
          ]
          ++ nixosModules;
      };

      hermes = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
            ./hosts/hermes
            (mkHostModule "hermes")
          ]
          ++ nixosModules;
      };

      farnsworth = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-gpu-amd
            ./hosts/farnsworth
            {nixpkgs = nixosSystemArgs;}
          ]
          ++ nixosModules;
      };
    };

    homeConfigurations = {
      "avanderbergh@zoidberg" = mkHomeConfig "zoidberg";
      "avanderbergh@hermes" = mkHomeConfig "hermes";
    };
  };
}
