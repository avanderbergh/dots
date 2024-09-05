{
  hardware = {
    graphics.enable32Bit = true;
    nvidia-container-toolkit.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  users.users.avanderbergh.extraGroups = ["docker"];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
    ];
  };
}
