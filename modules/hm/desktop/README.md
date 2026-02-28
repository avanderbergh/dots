# Niri Desktop Notes

## Core Workflow

- Window management and workspace navigation use Niri upstream defaults.
- `Super + Space` opens `fuzzel`.
- `Super + Return` opens `alacritty`.
- `Print` captures a region with `grim + slurp` and opens it in `satty`.
- `Ctrl + Print` captures the full screen and opens it in `satty`.

## Shell Components

- Bar: `waybar`
- Notifications: `swaynotificationcenter`
- Launcher: `fuzzel`
- Lock screen: `swaylock-effects`
- Idle daemon: `swayidle`
- Wallpaper: `wpaperd`
- Dynamic monitor profiles: `kanshi`

## Theming

- Stylix is the source of truth for desktop theming.
- Niri styling uses `programs.niri.settings` and Stylix integration from `niri-flake`.
