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
scripts/nix-dev-check.sh
```

Or run it without entering an interactive shell:

```sh
nix develop .#nixos-dots --command scripts/nix-dev-check.sh
```

## Dendritic Layout

`flake.nix` is intentionally thin. It declares inputs, enables `flake-parts.flakeModules.modules`, then imports every top-level module under [`modules`](./modules) and [`hosts`](./hosts) through `import-tree`.

The important invariant is that every `.nix` file under those imported roots is a flake-parts module. Feature files publish lower-level modules as stable names such as `flake.modules.nixos.vpn` or `flake.modules.homeManager."profile-desktop"`. Other files compose those features by name through `config.flake.modules`, not by importing their filesystem paths.

The dendritic layer is organized by concern:

- [`modules/repo`](./modules/repo) defines repository-level options, package sets, and developer shells.
- [`modules/configurations`](./modules/configurations) assembles public outputs from host and home registrations.
- [`hosts/*`](./hosts) publish host metadata, `dots.nixosHosts.<name>` registrations, and split host modules by concern.
- [`modules/nixos`](./modules/nixos) publish flattened NixOS feature modules.
- [`modules/hm`](./modules/hm) publish Home Manager user, profile, and integration modules.

If a raw helper file is ever needed under an imported tree, place it under a path segment beginning with `_`; `import-tree` ignores those paths by default.

## Notes

### Import GPG Keys

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 741eda0a1f942978d0e612ed938036d74671d8d5
```
