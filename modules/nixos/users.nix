{config, ...}: let
  inherit (config.dots) ownerSshKeys;
in {
  flake.modules.nixos.users = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mkOption types;
    owner = config.local.users.ownerName;
  in {
    options.local.users = {
      ownerName = mkOption {
        type = types.str;
        default = "avanderbergh";
        description = "Primary human owner username for this system.";
      };
    };

    config.users = {
      mutableUsers = false;
      manageLingering = true;
      groups.${owner} = {};
      users.${owner} = {
        isNormalUser = true;
        linger = true;
        createHome = true;
        home = "/home/${owner}";
        extraGroups = [
          owner
          "dialout"
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.fish;
        hashedPasswordFile = "/persist/passwords/${owner}";
        openssh.authorizedKeys.keys = ownerSshKeys;
      };
    };
  };
}
