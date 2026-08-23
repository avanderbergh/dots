{config, ...}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos."host-hermes" = {
    imports = [
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
