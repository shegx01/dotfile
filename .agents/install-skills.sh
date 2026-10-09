#!/bin/sh
# Install the global agent skills in skills.txt via the community skills CLI.
# The installed copies and their lock file are machine-local, so they're restored
# from the manifest instead of tracked. Safe to re-run; installed ones are skipped.
# Usage: sh ~/.agents/install-skills.sh

set -e

command -v npx >/dev/null 2>&1 || { echo "npx not found — install Node.js first"; exit 1; }

MANIFEST="$(cd "$(dirname "$0")" && pwd)/skills.txt"

grep -vE '^[[:space:]]*(#|$)' "$MANIFEST" | while read -r source skill; do
  if [ -f "$HOME/.agents/skills/$skill/SKILL.md" ] || [ -f "$HOME/.claude/skills/$skill/SKILL.md" ]; then
    echo "skill '$skill' already installed — skipping"
  else
    echo "Installing skill '$skill' from $source..."
    npx -y skills@latest add "$source" --skill "$skill" --agent claude-code --global --yes </dev/null
  fi
done

echo "Done. Update later with: npx skills update -g"
