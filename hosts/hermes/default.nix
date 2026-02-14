{
  config,
  lib,
  pkgs,
  ...
}: let
  owner = config.local.users.ownerName;
in {
  imports = [
    ./morbo-secrets.nix
    ../../modules/nixos/optional/ausweisapp.nix
    ../../modules/nixos/optional/cache-server.nix
    ../../modules/nixos/optional/cloudflared.nix
    ../../modules/nixos/optional/cloudflare-ssh-ca.nix
    ../../modules/nixos/optional/desktop.nix
    ../../modules/nixos/optional/containers.nix
    ../../modules/nixos/optional/ephemeral-btrfs.nix
    ../../modules/nixos/optional/ledger-live.nix
    ../../modules/nixos/optional/media-server.nix
    ../../modules/nixos/optional/nts-1.nix
    ../../modules/nixos/optional/ollama.nix
    ../../modules/nixos/optional/optin-persistence.nix
    ../../modules/nixos/optional/pentablet.nix
    ../../modules/nixos/optional/pipewire.nix
    ../../modules/nixos/optional/postgres.nix
    ../../modules/nixos/optional/quickemu.nix
    ../../modules/nixos/optional/secureboot.nix
    ../../modules/nixos/optional/video.nix
    ../../modules/nixos/optional/vpn.nix
    ../../modules/nixos/optional/yubikey.nix
  ];

  networking.hostName = "hermes";

  local.users.enableBotUsers = true;

  # Allow the configured human owner account to access and manage Morbo's workspace.
  users.users.${owner}.extraGroups = ["morbo"];

  # Ensure existing + newly created files under /home/morbo are accessible.
  system.activationScripts.owner-morbo-home-acl.text = ''
    if [ -d /home/morbo ]; then
      ${pkgs.acl}/bin/setfacl -R -m u:${owner}:rwx /home/morbo
      ${pkgs.acl}/bin/setfacl -R -d -m u:${owner}:rwx /home/morbo
    fi
  '';

  services.envfs.enable = true;

  programs.nix-ld.libraries = lib.mkAfter (with pkgs; [
    bzip2
    libffi
    ncurses
    openssl
    readline
    sqlite
    xz
    zlib
  ]);

  services.xserver = {
    dpi = 109;
    resolutions = [
      {
        x = 5120;
        y = 1440;
      }
    ];
  };

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "usbhid" "ahci"];
      kernelModules = ["tpm_tis"];
      luks.devices = {
        "enc".device = "/dev/disk/by-label/luks";
        "enc_ssd".device = "/dev/disk/by-label/luks_ssd";
        "enc_hdd".device = "/dev/disk/by-label/luks_hdd";
      };
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/home/avanderbergh/ssd" = {
      device = "/dev/mapper/enc_ssd";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "ssd"];
    };
    "/home/avanderbergh/hdd" = {
      device = "/dev/mapper/enc_hdd";
      fsType = "btrfs";
      options = ["autodefrag" "noatime"];
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024 * 16) + (1024 * 2);
    }
  ];

  hardware.graphics.enable = true;

  hardware.nvidia.open = true;

  programs.nh.flake = "/home/avanderbergh/repos/github.com/avanderbergh/dots/";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
