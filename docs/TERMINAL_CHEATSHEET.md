# Terminal & TUI Cheat Sheet

This cheat sheet covers the terminal tools configured in Home Manager (`modules/hm/console.nix`) and the key Neovim/tmux shortcuts currently set.

## Shell Basics

### Fish shell
- Shell: `fish`
- Prompt: `starship`
- Useful aliases:
  - `g` → `git`
  - `get` → `ghq get -p -u`
  - `create` → `ghq create`

### Navigation helpers
- `zoxide` (`z` command): jump to frequently used dirs
  - `z dots`
  - `zi` (interactive)
- `eza`: modern `ls`
  - `eza`
  - `eza -la`
  - `eza --tree`

### Search helpers
- `fd`: fast file finder
  - `fd neovim`
  - `fd "\.nix$" modules`
- `ripgrep` (`rg`): fast text search
  - `rg "programs\.neovim" modules`
- `fzf`: fuzzy finder for interactive filtering

---

## Git Tools

### lazygit
- Launch: `lazygit`
- Typical flow:
  - stage files
  - commit
  - push

### gitui
- Launch: `gitui`
- Keyboard-driven TUI for status/stage/commit/history.

---

## File Managers

### yazi
- Launch: `yazi`
- Keyboard-first file manager with previews.

### lf
- Launch: `lf`
- Lightweight terminal file manager.

---

## System / Disk / Code Stats

- `btop` / `bottom`: system monitoring
  - `btop`
  - `btm`
- `duf`: disk usage overview
  - `duf`
- `dust`: recursive folder size
  - `dust -d 2`
- `tokei`: lines of code stats
  - `tokei`

---

## Utility Tools

- `bat`: cat with syntax highlighting
  - `bat file.nix`
- `glow`: render markdown in terminal
  - `glow README.md`
- `just`: command runner
  - `just`
  - `just <recipe>`
- `tealdeer` (`tldr`): quick examples
  - `tldr rg`

Clipboard helpers installed for terminal/Neovim integration:
- `xclip` (X11)
- `wl-clipboard` (`wl-copy` / `wl-paste` on Wayland)

---

## tmux Cheat Sheet

Prefix key (default): `Ctrl-b`

### Session basics
- Start: `tmux`
- New named session: `tmux new -s work`
- Attach: `tmux attach -t work`
- List sessions: `tmux ls`

### Windows (tabs)
- New window: `Prefix c`
- Next/prev window: `Prefix n` / `Prefix p`
- Rename window: `Prefix ,`
- Close window: `exit` in shell (or `Prefix &`)

### Panes
- Split vertical: `Prefix |`
- Split horizontal: `Prefix -`
- Move panes: `Prefix h/j/k/l`
- Resize pane: `Prefix` then hold `Ctrl` + arrow keys

### Reload config
- `Prefix r`

Notes:
- Mouse is enabled.
- Window/pane indexing starts at 1.

---

## Neovim (VSCode-like) Cheat Sheet

Launch: `nvim`

### Core
- Save: `Ctrl-s`
- Quick Open: `Ctrl-p`
- Search in files: `Ctrl-f`
- Toggle file explorer: `Ctrl-b`
- Command palette: `Ctrl-Shift-p` (fallback: `<leader>p`)

### LSP navigation/actions
- Go to definition: `gd` or `F12`
- Find references: `gr` or `Shift-F12`
- Go to implementation: `gi`
- Hover docs: `K`
- Rename symbol: `F2`
- Code actions: `<leader>ca`
- Format file: `<leader>fm`

### Diagnostics
- Show diagnostics float: `<leader>xx`

### Telescope
- Find files: `<leader>ff`
- Live grep: `<leader>fg`

### Commenting
- Normal mode: `Ctrl-/`
- Visual mode: `Ctrl-/`

---

## Health / Troubleshooting

### Neovim health
```bash
nvim +'checkhealth'
```

### Verify key binaries
```bash
which nvim tmux rg fd bat lazygit gitui yazi tree-sitter xclip wl-copy
```

### Re-apply Home Manager
```bash
home-manager switch --flake .#avanderbergh@hermes
```
