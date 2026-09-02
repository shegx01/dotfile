#!/bin/sh
# Install the herdr plugins used by this config.
#
# herdr keeps installed plugins under ~/.config/herdr/plugins/github/ and tracks
# them in plugins.json — both machine-local, so they are gitignored and restored
# from here instead. Safe to re-run; already-installed plugins are skipped.
#
# Usage: sh ~/.config/herdr/install-plugins.sh

set -e

command -v herdr >/dev/null 2>&1 || { echo "herdr not found — brew install herdr"; exit 1; }

# plugin_id : owner/repo[/subdir]        # known-good commit at time of writing
install_plugin() {
  id="$1"
  src="$2"
  if herdr plugin list 2>/dev/null | grep -q "^- $id "; then
    echo "herdr plugin '$id' already installed — skipping"
  else
    echo "Installing herdr plugin '$id' from $src..."
    herdr plugin install "$src" --yes
  fi
}

# VS Code-style sidebar: file explorer + source control. Bound to prefix+b /
# ctrl+alt+b via [keys].toggle_sidebar, and configured by [ui.sidebar.agents].
install_plugin herdr-sidebar alexarthurs/herdr-sidebar/plugins/herdr-sidebar   # 13ebde8

# Restores panes/agents after a full server restart. Pairs with
# [experimental].pane_history; the program allowlist is in
# plugins/config/ntindle.herdr-resurrect/allowlist.txt.
install_plugin ntindle.herdr-resurrect ntindle/herdr-resurrect                 # 5afa675

# fzf-style project switcher (tmux-sessionizer equivalent).
install_plugin sessionizer andrewchng/herdr-sessionizer                        # e3cdab0

# Renames tabs from what the pane is actually doing.
install_plugin tab-smart-rename iurysza/herdr-tab-smart-rename                 # b646cc3

# Agent usage/quota readout in the status bar.
install_plugin usagebar senna-lang/herdr-agent-usage                           # cb6f142

echo "Done. Restart herdr (or: herdr server reload-config) to pick up changes."
