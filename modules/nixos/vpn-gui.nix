{
  flake.modules.nixos."vpn-gui" = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [proton-vpn];
  };
}
