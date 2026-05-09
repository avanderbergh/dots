{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos."host-hermes" = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      nixos."cache-server"
      nixos.cloudflared
      nixos."cloudflare-ssh-ca"
      nixos.containers
      nixos."ephemeral-btrfs"
      nixos."ledger-live"
      nixos."media-server"
      nixos."nts-1"
      nixos.ollama
      nixos."optin-persistence"
      nixos.postgres
      nixos.quickemu
      nixos.secureboot
      nixos.video
      nixos.vpn
      nixos.yubikey
      nixos."github-runner"
    ];
  };
}
