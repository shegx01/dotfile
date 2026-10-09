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
* [herdr](https://herdr.dev/) — Terminal multiplexer for AI coding agents
* [Orca](https://onorca.dev/) — IDE for orchestrating AI coding agents across worktrees
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

### herdr
Config lives in `.config/herdr/config.toml` (prefix is `ctrl+b`; `ctrl+space` is
unusable on macOS because the input-source switcher claims it).

Plugins are installed into `~/.config/herdr/plugins/` at runtime, so the payloads
and `plugins.json` are gitignored. Restore them with:
```bash
sh ~/.config/herdr/install-plugins.sh
```
That installs:
* [herdr-sidebar](https://github.com/alexarthurs/herdr-sidebar) — File explorer + source control pane
* [herdr-resurrect](https://github.com/ntindle/herdr-resurrect) — Restores panes and agents after a restart
* [sessionizer](https://github.com/andrewchng/herdr-sessionizer) — fzf project switcher
* [tab-smart-rename](https://github.com/iurysza/herdr-tab-smart-rename) — Names tabs from what the pane is doing
* [agent-usage](https://github.com/senna-lang/herdr-agent-usage) — Agent usage readout in the status bar

Plugin settings that are worth keeping (the herdr-resurrect allowlist and
settings) are tracked under `.config/herdr/plugins/config/`.

### Orca
Orca has no config file; its settings live in a SQLite profile store under
`~/Library/Application Support/orca/`. `.config/orca/settings.json` is a snapshot
of just the settings document (secrets, linked accounts and per-machine keys
stripped), round-tripped by `.config/orca/sync-settings.sh`:

* `sh ~/.config/orca/sync-settings.sh export` refreshes the snapshot from the app
* `sh ~/.config/orca/sync-settings.sh apply` merges it back in (quit Orca first;
  the profile DB is backed up alongside it). On a new machine, launch Orca once
  so it creates its profile, quit it, then apply.

### Agent skills
Global skills (Orca, herdr, Astro, design, writing) are listed in
`.agents/skills.txt` and installed by `.agents/install-skills.sh` through the
[skills CLI](https://github.com/vercel-labs/skills). The installed copies and
`~/.agents/.skill-lock.json` stay machine-local. Add a skill with
`npx skills add <owner/repo> --skill <name> -g`, then add its line to the manifest.

### SketchyBar
The config is done entirely in Lua (and some C), using
[SbarLua](https://github.com/FelixKratz/SbarLua).
One-line install for sketchybar config (requires brew):
```bash
curl -L https://raw.githubusercontent.com/shegx01/dotfile/main/install_sketchybar.sh | sh
```
