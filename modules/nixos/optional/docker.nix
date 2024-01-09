{
  hardware.opengl.driSupport32Bit = true;
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    storageDriver = "btrfs";
  };
  users.users.avanderbergh.extraGroups = ["docker"];

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/docker"
    ];
  };
}
