{
  flake.modules.nixos.networking = {lib, ...}: {
    networking = {
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
      firewall.enable = true;
    };
  };
}
