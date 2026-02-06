# Agent Notes For This Repository

## Start Here
- Read `README.md` first for a high-level understanding of what this repository manages.
- Treat `flake.nix` and files under `hosts/` and `modules/` as the source of truth.

## Where To Find Project Facts
- NixOS host definitions: `hosts/*/default.nix`
- Flake outputs and host/home wiring: `flake.nix`
- System user policy (human vs bot account type): `modules/nixos/global/users.nix`
- Home Manager user modules: `modules/hm/users/*.nix`
- Bot Home Manager stack: `modules/hm/bot/*.nix`

## Required Before Running Nix Commands
- Determine the current machine first:
  - `hostname --short` (fallback: `hostnamectl --static`)
- Verify that hostname exists in:
  - `hosts/<hostname>/default.nix`
  - `flake.nix` outputs for the command you plan to run
- Use explicit flake targets (for example `.#<hostname>` or `.#<user>@<hostname>`), never guessed values.

## Behavior Expectations
- Do not hard-code hostnames, usernames, or role mappings in docs/scripts when they can be read from the source files above.
- If host/user context is unclear, inspect source files first and only then run Nix commands.
