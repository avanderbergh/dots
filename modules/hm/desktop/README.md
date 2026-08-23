# Niri Desktop Notes

## Core Workflow

- Window management and workspace navigation use Niri upstream defaults.
- `Super + Space` opens the Noctalia launcher.
- `Super + Return` opens Kitty.
- `Super + Alt + L` opens the Noctalia lock screen.
- `Super + Shift + C` toggles Noctalia caffeine mode to inhibit idle suspend.
- `Super + O` opens Niri's wallpaper-backed overview.
- `Super/Alt + Tab` opens Niri's themed recent-window switcher.
- `Super + W` toggles the focused column between tiled and tabbed layouts.
- `Super + V` toggles the focused window between tiled and floating.
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
- Niri derives its mauve-to-blue focus gradient, shadows, overview, tabs, and
  recent-window switcher directly from the shared Stylix palette.
- Noctalia provides the blurred, tinted wallpaper backdrop for Niri's overview;
  Niri provides restrained blur for translucent windows and shell surfaces.
- Kitty uses the shared Catppuccin palette at 82% background opacity, without
  client-side window decorations; Niri draws its focus ring around the window.
