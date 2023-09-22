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
        extraGroups = ["wheel" "networkmanager" "dialout"];
        hashedPasswordFile = "/persist/passwords/avanderbergh";
        shell = pkgs.fish;
      };
    };
  };
}
