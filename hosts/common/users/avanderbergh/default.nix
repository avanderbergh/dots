{ config, pkgs, ... }: {
  users = {
    mutableUsers = false;
    users = {
      avanderbergh = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        passwordFile = "/persist/passwords/avanderbergh";
        shell = pkgs.fish;
      };
    };
  };

  home-manager.users.avanderbergh =
    import home/${config.networking.hostName}.nix;

}
