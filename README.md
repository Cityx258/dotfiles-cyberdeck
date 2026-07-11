# dotfiles

My Hyprland setup, running on a Raspberry Pi 5. Minimal, sharp-cornered, purple accent — a "cyberdeck" look: thin borders, subtle blur, no shadows, dwindle layout.

## Layout

| Directory | Software | Notes |
|---|---|---|
| [`hypr/`](hypr) | [Hyprland](https://hyprland.org) | Window manager. Split into `monitors`, `programs`, `autostart`, `envs`, `appearance`, `input`, `keybinds`, `windowrules`, all sourced from `hyprland.conf`. Includes `scripts/rotate-displays.sh`, a rofi-driven per-monitor rotation helper. |
| [`waybar/`](waybar) | [Waybar](https://github.com/Alexays/Waybar) | Status bar — workspaces, clock, CPU, memory, battery — with custom hex-styled SVG icons. |
| [`rofi/`](rofi) | [Rofi](https://github.com/davatorium/rofi) | App launcher (`drun`) and a web-search mode powered by [rofi-web-search](https://github.com/OSDVF/rofi-web-search) (installed separately; `rofi-web-search.config.json` is my config for it). |
| [`dunst/`](dunst) | [Dunst](https://dunst-project.org) | Notification daemon. |
| [`kitty/`](kitty) | [Kitty](https://sw.kovidgoyal.net/kitty/) | Terminal emulator. |
| [`cava/`](cava) | [Cava](https://github.com/karlstav/cava) | Audio visualizer, with custom GLSL shaders and color themes. |
| [`fastfetch/`](fastfetch) | [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info fetch. |
| [`touchegg/`](touchegg) | [Touchégg](https://github.com/JoseExposito/touchegg) | Touchscreen/touchpad gesture daemon. |
| [`lazygit/`](lazygit) | [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI. |
| [`micro/`](micro) | [Micro](https://micro-editor.github.io) | Terminal text editor keybindings. |
| [`termusic/`](termusic) | [Termusic](https://github.com/tramhao/termusic) | Terminal music player. |
| [`zsh/`](zsh) | Zsh + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Shell config and prompt theme. |
| [`git/`](git) | Git | Global `.gitconfig`. |

## Highlights

- **Theme**: purple (`#a020f0`) accents, 0px rounding, 2px borders, blur enabled but shadows off.
- **Keybinds**: `SUPER` as the main mod — `T` terminal, `Q` kill, `A` launcher, `E` file manager, `SHIFT+S` web search via rofi, `SHIFT+R` display rotation script.
- Built for a small/rotatable touchscreen setup on a Pi 5 — see `hypr/monitors.conf` and `hypr/scripts/rotate-displays.sh`.

## Usage

These aren't a one-shot install script — copy the pieces you want into `~/.config/<app>/`, adjust paths (wallpaper path in `hypr/autostart.conf`, monitor names in `hypr/monitors.conf`) to match your own system, and restart the relevant app or reload Hyprland (`hyprctl reload`).
