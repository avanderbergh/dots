---
name: nixos-dots
description: "Run the Nix quality workflow for this repository with one command: format with alejandra, lint with statix, syntax-check changed Nix files, and run nix flake check with trace output. Use when editing `.nix` files, validating host/home config changes, or preparing a commit in this repo."
---

# Nixos Dots

Run the script in `scripts/nix-dev-check.sh` to perform repository checks in one pass with readable status output.

## Run The Workflow

Run from anywhere:

```bash
.agents/skills/nixos-dots/scripts/nix-dev-check.sh
```

Run read-only validation (no file edits):

```bash
.agents/skills/nixos-dots/scripts/nix-dev-check.sh --check
```

Pass extra arguments to `nix flake check`:

```bash
.agents/skills/nixos-dots/scripts/nix-dev-check.sh -- --keep-going
```

## Script Behavior

Follow this sequence:

1. Resolve the repository root.
2. Print environment context (repo root, hostname, tool versions).
3. Validate hostname wiring hints (`hosts/<hostname>/default.nix` and flake mentions).
4. Parse changed `.nix` files with `nix-instantiate --parse`.
5. Run `alejandra` in fix mode (default) or check mode (`--check`).
6. Run `statix check --format errfmt` on changed files (or full repo with `--lint-all`).
7. Run `git add -A` to stage all repository changes so flake evaluation includes new files.
8. Check for untracked files and block flake checks by default (git flakes ignore untracked files).
9. Run `nix flake check --show-trace -L`.
10. Print a concise summary with pass/fail states.

## Options

- `--check`: Run `alejandra --check .` instead of modifying files.
- `--skip-parse`: Skip syntax parsing of changed `.nix` files.
- `--skip-lint`: Skip `statix` lint checks.
- `--lint-all`: Run `statix` against the full repository instead of changed files.
- `--skip-flake-check`: Skip `nix flake check`.
- `--allow-untracked`: Force flake check even when untracked files exist.
- `--no-auto-add`: Skip the automatic `git add -A` step.
- `--help`: Print usage.
- `--`: Treat remaining args as additional `nix flake check` args.

## Use During Editing

Use default mode while iterating to auto-format before evaluation.
Use `--check` before commit if you want a non-mutating validation pass.
Use `--lint-all` before larger refactors when you want full-repository lint visibility.
The script stages all files automatically before flake checks; use `--no-auto-add` if you need to inspect unstaged changes first.
If untracked files still remain, add them to git before expecting `nix flake check` to pass (or use `--allow-untracked` when intentionally testing).
Fix reported syntax errors before rerunning full flake checks for faster feedback.
