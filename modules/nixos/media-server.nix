{
  flake.modules.nixos."media-server" = {
    # https://github.com/NixOS/nixpkgs/issues/353600

    services.jellyfin = {
      enable = true;
      openFirewall = true;
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
