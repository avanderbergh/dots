{...}: {
  home = {
    username = "morbo";
    homeDirectory = "/home/morbo";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };
}
