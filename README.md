# dotfiles
My macOS configuration files.

## Tools

### Window Management
* [yabai](https://github.com/koekeishiya/yabai) — Tiling window manager
* [skhd](https://github.com/koekeishiya/skhd) — Hotkey daemon
* [JankyBorders](https://github.com/FelixKratz/JankyBorders) — Window borders
* [SketchyBar](https://github.com/FelixKratz/SketchyBar) — Custom menu bar
* [SketchyVim](https://github.com/FelixKratz/SketchyVim) — System-wide Vim keybindings

### Terminal & Editors
* [Ghostty](https://ghostty.org/) — GPU-accelerated terminal
* [Helix](https://helix-editor.com/) — Terminal text editor (with LSP for Elixir, Rust, TOML, JSON)
* [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/) — IDE-like Neovim config
* [Starship](https://starship.rs/) — Shell prompt
* [zoxide](https://github.com/ajeetdsouza/zoxide) — Smarter cd

### Browsers
* [Orion](https://browser.kagi.com/) — WebKit browser with extension support
* [Brave](https://brave.com/)

### Dev Tools
* [Docker](https://www.docker.com/)
* [DataGrip](https://www.jetbrains.com/datagrip/) — Database IDE
* [Apidog](https://apidog.com/) — API development
* [asdf](https://asdf-vm.com/) — Version manager (Erlang, Node.js, Elixir, Rust)
* [GnuPG](https://gnupg.org/)

### Communication
* [Slack](https://slack.com/)
* [Telegram](https://telegram.org/)

### Utilities
* [nnn](https://github.com/jarun/nnn) — Terminal file manager (custom fork)
* [Sloth](https://sveinbjorn.org/sloth) — Process inspector
* [btop](https://github.com/aristocratos/btop) — System monitor
* [lazygit](https://github.com/jesseduffield/lazygit) — Git TUI

## Setup

Most setup steps are in `.install.sh`

### SketchyBar
The config is done entirely in Lua (and some C), using
[SbarLua](https://github.com/FelixKratz/SbarLua).
One-line install for sketchybar config (requires brew):
```bash
curl -L https://raw.githubusercontent.com/shegx01/dotfiles/master/install_sketchybar.sh | sh
```
# dotfile
# dotfile
