{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.dots) homeModules packageSets standaloneHomeModules;
  inherit (packageSets) pkgs;

  mkHomeConfig = key: let
    modules =
      homeModules.${key}
      ++ (standaloneHomeModules.${key} or []);
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit modules pkgs;
    };
in {
  flake.homeConfigurations = lib.genAttrs (builtins.attrNames homeModules) mkHomeConfig;
}
