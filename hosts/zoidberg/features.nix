{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos."host-zoidberg" = {
    imports = [
      inputs.nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
      inputs.niri.nixosModules.niri
      nixos.ausweisapp
      nixos.bluetooth
      nixos.desktop
      nixos.containers
      nixos."ephemeral-btrfs"
      nixos.laptop
      nixos."ledger-live"
      nixos.ollama
      nixos."optin-persistence"
      nixos."pipewire-sof-workarounds"
      nixos.pipewire
      nixos.postgres
      nixos."host-zoidberg-qca6390-wifi-fix"
      nixos.secureboot
      nixos.vpn
      nixos."vpn-gui"
      nixos.yubikey
    ];
  };
}
