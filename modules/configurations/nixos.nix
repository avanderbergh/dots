{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.dots) homeModules nixosHosts nixpkgsArgs system;

  hmKeysForHost = hostName:
    lib.filter (key: let
      parts = lib.splitString "@" key;
    in
      builtins.length parts == 2 && builtins.elemAt parts 1 == hostName)
    (builtins.attrNames homeModules);

  hmUsersForHost = hostName:
    builtins.listToAttrs (map (key: let
        parts = lib.splitString "@" key;
        userName = builtins.elemAt parts 0;
      in {
        name = userName;
        value = {imports = homeModules.${key};};
      })
      (hmKeysForHost hostName));

  mkNixpkgsModule = {
    nixpkgs = nixpkgsArgs;
  };

  mkHomeManagerModule = hostName: {
    nixpkgs = nixpkgsArgs;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      users = hmUsersForHost hostName;
    };
  };

  mkHost = hostName: hostConfig:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        hostConfig.modules
        ++ [
          (
            if hostConfig.enableHomeManager
            then mkHomeManagerModule hostName
            else mkNixpkgsModule
          )
        ];
    };
in {
  flake.nixosConfigurations = lib.mapAttrs mkHost nixosHosts;
}
