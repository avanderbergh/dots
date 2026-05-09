{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.dots = {
    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "Default system used for this repository's NixOS and Home Manager outputs.";
    };

    systems = mkOption {
      type = types.listOf types.str;
      default = ["x86_64-linux"];
      description = "Systems exposed through flake-parts perSystem outputs.";
    };

    desktops = mkOption {
      type = types.listOf types.str;
      default = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "10"];
      description = "Workspace names shared by host monitor metadata.";
    };

    colors = mkOption {
      type = types.attrs;
      default = import (inputs.self + /lib/theme/colors.nix);
      description = "Shared theme color constants.";
    };

    hostConfigs = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = "Host metadata published by host feature modules.";
    };

    nixosHosts = mkOption {
      type = types.lazyAttrsOf (types.submodule {
        options = {
          modules = mkOption {
            type = types.listOf types.deferredModule;
            default = [];
            description = "NixOS modules used to build this host.";
          };

          enableHomeManager = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to attach matching Home Manager user modules to this host.";
          };
        };
      });
      default = {};
      description = "NixOS hosts published by imported host modules.";
    };

    nixpkgsArgs = mkOption {
      type = types.attrs;
      readOnly = true;
      description = "Nixpkgs arguments shared by system builds and package set imports.";
    };

    packageSets = mkOption {
      type = types.attrs;
      readOnly = true;
      description = "Pinned package sets used across NixOS and Home Manager modules.";
    };

    homeModules = mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      default = {};
      description = "Home Manager module stacks keyed by user@host.";
    };

    standaloneHomeModules = mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      default = {};
      description = "Extra Home Manager modules used only by standalone homeConfigurations.";
    };
  };

  config = {
    inherit (config.dots) systems;
  };
}
