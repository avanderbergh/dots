{
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };
  users.users.avanderbergh.extraGroups = ["docker"];
}
