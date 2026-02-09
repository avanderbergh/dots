{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.local.users;
  ownerSshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC70ed167oK/Ka8JTMCLF3mH+kUO7SRirjkFRu4zRgQBhTVTVwuHm8TLi0Jzs+PBbTBXDlomSTS5ft6hs4xt+VQagRh2mrekfPGbAeE9NBWhHhujkMu4jT9q4nS6qTzaw9m+LiwXpZz0SP6SV9jFL78TTFUqtSAF2qSHIOHDVJFYra2Co0UHeJv1zYKx3bVJ5KXOXzP7jgNKDk6o5xtoS0owL3jxXPdpbr1qV3jAQik5acH0NYaNgbgwVoHEMJ14O5GzH705wTZR0ljW1Ysl+/tqY0mRhwMneyPp6tyzgF56UMSjfTCJCCGPwJxYnhEOm1D3tB2f2ZARmcLCknWF1LzCCKKyR5qULv3ffQ8U+3R56051QHh9Qjt+5dDWuRnj1m2Zd2WbfUl0ZtejKWTPzXLE6ABb9SX7eNbFonK+3mRLLvrFd+pFIAKmDORVPVBhy/na/1C//HotmzlAQ4nwRVGzXVvjiZIrEHfdbrCBQO3aYFIFSWqwckRuO3fjya4N8lVigq+LqavrcuGdBdg2/Y+HCvSzQxBKPgzGdjPACpIraQHG7LwigCRnDNB4myIoni40bdR7OHh3ZL4315mxscbhyjdKuBuMQI8U4An059MR29AqLU8KplSooPSEs1ERJ8XKnJeFK16W4s08+zVExJNDJm8dXAQJXbgIPKPepO0Mw== cardno:13_075_747";

  mkUser = name: userType:
    assert builtins.elem userType ["human" "bot"]; let
      isHuman = userType == "human";
    in
      with pkgs;
        {
          isNormalUser = isHuman;
          isSystemUser = !isHuman;
          linger = !isHuman;
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
        };

  userDefs =
    {(cfg.ownerName) = "human";}
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
}
