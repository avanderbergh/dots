{
  flake.modules.nixos.quickemu = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.quickemu
    ];
  };
}
