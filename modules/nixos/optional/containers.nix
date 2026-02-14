{config, lib, pkgs, ...}: {
  hardware = {
    graphics.enable32Bit = true;
    nvidia-container-toolkit.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };

    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users = {
    avanderbergh.extraGroups = ["docker"];
  } // lib.optionalAttrs config.local.users.enableBotUsers {
    morbo.extraGroups = ["docker"];
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    buildah
    skopeo
    crun
    runc
  ];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
      "/var/lib/containers"
    ];
  };
}
