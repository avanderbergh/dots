# NixOS Configurations

Welcome to my NixOS configurations repository! This is where I manage the setup for my personal machines using Nix Flakes.

## Hosts

### Zoidberg

- **Hostname**: `zoidberg`
- **Configuration File**: [./hosts/zoidberg](./hosts/zoidberg)
- **Machine**: Dell XPS 17 9700
- **Specs**: 32GB RAM | 1TB SSD

### Hermes

- **Hostname**: `hermes`
- **Configuration File**: [./hosts/hermes](./hosts/hermes)
- **Machine**: HP Pavilion TG01-0004ng
- **Specs**: Ryzen 7 3700X | 16GB RAM | 1TB + 512GB SSD | RTX 2060, 8GB

### Farnsworth

- **Hostname**: `farnsworth`
- **Configuration File**: [./hosts/farnsworth](./hosts/farnsworth)
- **Machine**: Fujitsu Futro S720

Feel free to explore the configurations and see how everything is set up!

## Development Shell

A dev shell is provided in `flake.nix` so you can run the repository checks with all required tools (`nix`, `git`, `ripgrep`, `alejandra`, `statix`) available.

Enter the shell:

```sh
# Default shell (same toolset as nixos-dots)
nix develop

# Explicit shell name
nix develop .#nixos-dots
```

Run the Nix workflow from the shell:

```sh
.agents/skills/nixos-dots/scripts/nix-dev-check.sh
```

Or run it without entering an interactive shell:

```sh
nix develop .#nixos-dots --command .agents/skills/nixos-dots/scripts/nix-dev-check.sh
```

## Notes

### Import GPG Keys

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 741eda0a1f942978d0e612ed938036d74671d8d5
```
