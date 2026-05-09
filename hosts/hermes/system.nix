{
  flake.modules.nixos."host-hermes" = {
    networking.hostName = "hermes";
    programs.nh.flake = "/home/avanderbergh/repos/github.com/avanderbergh/dots/";
    system.stateVersion = "23.11";
  };
}
