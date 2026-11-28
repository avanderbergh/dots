{
  flake.modules.nixos."media-server" = {config, ...}: let
    ownerHome = config.users.users.${config.local.users.ownerName}.home;
    mediaDir = "${ownerHome}/ssd/media";
  in {
    # https://github.com/NixOS/nixpkgs/issues/353600

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    systemd.services.jellyfin = {
      unitConfig.RequiresMountsFor = [mediaDir];
      serviceConfig = {
        ProtectHome = "tmpfs";
        BindReadOnlyPaths = [mediaDir];
      };
    };

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
        mode = "0700";
      }
    ];
  };
}
