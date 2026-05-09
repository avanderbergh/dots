{
  flake.modules.nixos."host-zoidberg" = {
    networking.hostName = "zoidberg";
    programs.nh.flake = "/home/avanderbergh/repos/github.com/avanderbergh/dots/";
    system.stateVersion = "23.11";
  };
}
