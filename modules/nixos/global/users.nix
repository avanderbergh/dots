{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      avanderbergh = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        passwordFile = "/persist/passwords/avanderbergh";
        shell = pkgs.fish;
      };
    };
  };
}
