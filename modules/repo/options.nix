{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  options.dots = {
    system = mkOption {
      type = types.str;
      default = "x86_64-linux";
      description = "Default system used for this repository's NixOS and Home Manager outputs.";
    };

    systems = mkOption {
      type = types.listOf types.str;
      default = ["x86_64-linux"];
      description = "Systems exposed through flake-parts perSystem outputs.";
    };

    ownerSshKeys = mkOption {
      type = types.listOf types.str;
      default = [
        # Primary YubiKey 5C NFC (FIDO2 resident ed25519-sk)
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHkQacpGJ9DDm7jMUbmFZ3ymdgU9br6j/riAvV39dyIpAAAABHNzaDo= avanderbergh@yk5-15282904"
        # Backup YubiKey 5C (FIDO2 resident ed25519-sk)
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIGBANjFRrz+t95yrXcsQwnpNTWu+RRmh8wm/xyK75mtxAAAABHNzaDo= avanderbergh@yk5-13075747"
        # Legacy OpenPGP RSA key (kept temporarily during Stage 1 cutover; remove in Stage 2)
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC70ed167oK/Ka8JTMCLF3mH+kUO7SRirjkFRu4zRgQBhTVTVwuHm8TLi0Jzs+PBbTBXDlomSTS5ft6hs4xt+VQagRh2mrekfPGbAeE9NBWhHhujkMu4jT9q4nS6qTzaw9m+LiwXpZz0SP6SV9jFL78TTFUqtSAF2qSHIOHDVJFYra2Co0UHeJv1zYKx3bVJ5KXOXzP7jgNKDk6o5xtoS0owL3jxXPdpbr1qV3jAQik5acH0NYaNgbgwVoHEMJ14O5GzH705wTZR0ljW1Ysl+/tqY0mRhwMneyPp6tyzgF56UMSjfTCJCCGPwJxYnhEOm1D3tB2f2ZARmcLCknWF1LzCCKKyR5qULv3ffQ8U+3R56051QHh9Qjt+5dDWuRnj1m2Zd2WbfUl0ZtejKWTPzXLE6ABb9SX7eNbFonK+3mRLLvrFd+pFIAKmDORVPVBhy/na/1C//HotmzlAQ4nwRVGzXVvjiZIrEHfdbrCBQO3aYFIFSWqwckRuO3fjya4N8lVigq+LqavrcuGdBdg2/Y+HCvSzQxBKPgzGdjPACpIraQHG7LwigCRnDNB4myIoni40bdR7OHh3ZL4315mxscbhyjdKuBuMQI8U4An059MR29AqLU8KplSooPSEs1ERJ8XKnJeFK16W4s08+zVExJNDJm8dXAQJXbgIPKPepO0Mw=="
      ];
      description = "Owner SSH public keys shared across authorized_keys and Git allowed_signers.";
    };

    ownerGitSigningKey = mkOption {
      type = types.str;
      # Keep legacy RSA key for Git signing until Stage 2 switches to OpenSSH ssh-agent.
      default = lib.last config.dots.ownerSshKeys;
      description = "Owner SSH public key used as the default Git commit signing key.";
    };

    hostConfigs = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      description = "Host metadata published by host feature modules.";
    };

    nixosHosts = mkOption {
      type = types.lazyAttrsOf (types.submodule {
        options = {
          modules = mkOption {
            type = types.listOf types.deferredModule;
            default = [];
            description = "NixOS modules used to build this host.";
          };

          enableHomeManager = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to attach matching Home Manager user modules to this host.";
          };
        };
      });
      default = {};
      description = "NixOS hosts published by imported host modules.";
    };

    nixpkgsArgs = mkOption {
      type = types.attrs;
      readOnly = true;
      description = "Nixpkgs arguments shared by system builds and package set imports.";
    };

    packageSets = mkOption {
      type = types.attrs;
      readOnly = true;
      description = "Pinned package sets used across NixOS and Home Manager modules.";
    };

    homeModules = mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      default = {};
      description = "Home Manager module stacks keyed by user@host.";
    };

    standaloneHomeModules = mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      default = {};
      description = "Extra Home Manager modules used only by standalone homeConfigurations.";
    };
  };

  config = {
    inherit (config.dots) systems;
  };
}
