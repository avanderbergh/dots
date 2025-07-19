# Copilot Custom Instructions

## Project Context

This repository contains NixOS configurations managed using Nix Flakes. The primary language is Nix.

## Key Repository Structure & Conventions

- **Nix Flakes:** The core of the configuration management. See [`flake.nix`](../flake.nix) and [`flake.lock`](../flake.lock).
- **Hosts:** Machine-specific configurations are located in the [`./hosts/`](../hosts/) directory. Each host has a subdirectory (e.g., [`./hosts/zoidberg`](../hosts/zoidberg)). Refer to the [README.md](../README.md) for a list of hosts.
- **NixOS Modules:** System-wide configurations are defined in [`./modules/nixos/`](../modules/nixos/).
  - Global settings: [`./modules/nixos/global/`](../modules/nixos/global/)
  - Optional features: [`./modules/nixos/optional/`](../modules/nixos/optional/)
- **Home Manager:** User-specific configurations (dotfiles, user packages, services) are managed via Home Manager modules located in [`./modules/hm/`](../modules/hm/).
- **Custom Packages:** Custom or overridden packages are defined in the [`./pkgs/`](../pkgs/) directory.
- **Secrets:** Secrets are managed using `sops-nix`. See relevant modules in [`modules/nixos/global/sops.nix`](../modules/nixos/global/sops.nix) and [`modules/hm/sops.nix`](../modules/hm/sops.nix).
- **README:** The main [README.md](../README.md) file provides a high-level overview of the repository structure and hosts. Please refer to it for more details.

## External Resources & Searching

- **NixOS Manual (Unstable):** [https://nixos.org/manual/nixos/unstable/](https://nixos.org/manual/nixos/unstable/)

## Agent Mode

- After making changes to Nix files (`.nix`), always run `nix flake check` in the terminal to validate the syntax and structure of the flake!
- Always format your code changes using `alejandra`!
- Before adding new packages in Nix expressions, search for them with `nix search nixpkgs <regex>`
