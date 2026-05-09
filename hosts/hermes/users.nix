{
  flake.modules.nixos."host-hermes" = {
    config,
    pkgs,
    ...
  }: let
    owner = config.local.users.ownerName;
  in {
    local.users.enableBotUsers = true;

    # Allow the configured human owner account to access and manage Morbo's workspace.
    users.users.${owner}.extraGroups = ["morbo"];

    # Ensure existing + newly created files under /home/morbo are accessible.
    system.activationScripts.owner-morbo-home-acl.text = ''
      if [ -d /home/morbo ]; then
        ${pkgs.acl}/bin/setfacl -R -m u:${owner}:rwx /home/morbo
        ${pkgs.acl}/bin/setfacl -R -d -m u:${owner}:rwx /home/morbo
      fi
    '';
  };
}
