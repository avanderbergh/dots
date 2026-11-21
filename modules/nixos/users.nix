{config, ...}: let
  inherit (config.dots) ownerSshKey;
in {
  flake.modules.nixos.users = {
    config,
    pkgs,
    lib,
    ...
  }:
    with lib; let
      cfg = config.local.users;

      mkUser = name: userType:
        assert builtins.elem userType ["human" "bot"]; let
          isHuman = userType == "human";
        in
          with pkgs;
            {
              isNormalUser = isHuman;
              isSystemUser = !isHuman;
              linger = true;
              createHome = true;
              home = "/home/${name}";
              extraGroups =
                [name]
                ++ optionals isHuman [
                  "dialout"
                  "networkmanager"
                  "wheel"
                ];
              shell =
                if isHuman
                then fish
                else bash;
              openssh.authorizedKeys.keys = [ownerSshKey];
            }
            // optionalAttrs isHuman {
              hashedPasswordFile = "/persist/passwords/${name}";
            }
            // optionalAttrs (!isHuman) {
              group = name;
              # Rootless containers (Podman) require subordinate ID ranges.
              # Keep bots as system users, but grant explicit subuid/subgid mappings.
              subUidRanges = [
                {
                  startUid = 200000;
                  count = 65536;
                }
              ];
              subGidRanges = [
                {
                  startGid = 200000;
                  count = 65536;
                }
              ];
            };

      userDefs =
        {"${cfg.ownerName}" = "human";}
        // optionalAttrs cfg.enableBotUsers {morbo = "bot";};
    in {
      options.local.users = {
        enableBotUsers = mkEnableOption "Enable bot user accounts on this host";
        ownerName = mkOption {
          type = types.str;
          default = "avanderbergh";
          description = "Primary human owner username for this system.";
        };
      };

      config.users = {
        mutableUsers = false;
        manageLingering = true;
        groups = genAttrs (builtins.attrNames userDefs) (_: {});
        users = mapAttrs mkUser userDefs;
      };
    };
}
