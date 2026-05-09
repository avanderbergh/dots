# Agent Notes For This Repository

## Start Here
- Read `README.md` first for a high-level understanding of what this repository manages.
- Treat `flake.nix` and files under `hosts/` and `modules/` as the source of truth.

## Where To Find Project Facts
- NixOS host definitions: `hosts/*/*.nix`, with host output registrations in `hosts/*/default.nix`
- Flake entrypoint: `flake.nix`
- Repository-level dendritic options and package sets: `modules/repo/*.nix`
- Host/home output assembly: `modules/configurations/*.nix`
- NixOS host output registrations: `dots.nixosHosts.<hostname>` in `hosts/<hostname>/default.nix`
- Host feature stacks, hardware, and local policy: sibling files in `hosts/<hostname>/`
- Published NixOS/Home Manager features: `flake.modules.*` definitions in `hosts/` and `modules/`
- System user policy (human vs bot account type): `modules/nixos/users.nix`
- Home Manager user modules: `modules/hm/users/*.nix`
- Bot Home Manager stack: `modules/hm/bot/*.nix`

## Required Before Running Nix Commands
- Determine the current machine first:
  - `hostname --short` (fallback: `hostnamectl --static`)
- Verify that hostname exists in:
  - `hosts/<hostname>/default.nix`
  - `dots.nixosHosts.<hostname>` in that host file
- Use explicit flake targets (for example `.#<hostname>` or `.#<user>@<hostname>`), never guessed values.

## Behavior Expectations
- Every `.nix` file under `hosts/` and `modules/` is imported by `import-tree` as a top-level flake-parts module.
- Keep `hosts/<hostname>/default.nix` small: it should identify and register the host, while sibling files contribute the actual host module.
- Compose internal NixOS and Home Manager modules through stable `config.flake.modules.<class>.<name>` references; do not add raw relative imports between feature files.
- Put raw helper files under an `_` path segment if they must live below an imported tree.
- Do not hard-code hostnames, usernames, or role mappings in docs/scripts when they can be read from the source files above.
- If host/user context is unclear, inspect source files first and only then run Nix commands.
