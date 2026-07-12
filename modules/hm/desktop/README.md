# Niri Desktop Notes

## Core Workflow

- Window management and workspace navigation use Niri upstream defaults.
- `Super + Space` opens the Noctalia launcher.
- `Super + Return` opens `alacritty`.
- `Super + Alt + L` opens the Noctalia lock screen.
- `Super + Shift + C` toggles Noctalia caffeine mode to inhibit idle suspend.
- `Print` captures a region with `grim + slurp` and opens it in `satty`.
- `Ctrl + Print` captures the full screen and opens it in `satty`.

## Shell Components

- Shell: Noctalia v5 (left vertical bar, launcher, notifications, lock screen,
  idle handling, wallpaper, OSD, clipboard history, and control center)
- Suspend event bridge: `swayidle` locks Noctalia before external suspend paths
- Dynamic monitor profiles: `kanshi`

## Theming

- Stylix is the source of truth for desktop theming.
- Stylix gives Noctalia the same Catppuccin Mocha palette and Recursive Mono
  family as the rest of the desktop; the bar uses `RecMonoLinear Nerd Font Mono`.
- Niri styling uses `programs.niri.settings` and Stylix integration from `niri-flake`.
