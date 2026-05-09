{
  flake.modules.nixos."host-farnsworth" = {pkgs, ...}: {
    networking.hostName = "farnsworth";

    environment.systemPackages = with pkgs; [
      cryptsetup
    ];

    programs.nh.flake = "/home/avanderbergh/dots/";
    system.stateVersion = "23.11";
  };
}
