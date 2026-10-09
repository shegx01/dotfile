#!/bin/sh
# Snapshot/restore Orca settings. Orca keeps them as one JSON document in its
# SQLite profile store, so only that document round-trips through settings.json.
# New machine: launch Orca once, quit it, then run this with `apply`.
# Usage: sh ~/.config/orca/sync-settings.sh export|apply

set -e

ORCA_DIR="${ORCA_DIR:-$HOME/Library/Application Support/orca}"
SNAPSHOT="$(cd "$(dirname "$0")" && pwd)/settings.json"

# Keys never written to the snapshot: credentials, linked accounts, telemetry
# ids, device/host selections and anything else that only makes sense here.
DROP_KEYS='[
  "telemetry", "opencodeSessionCookie", "opencodeWorkspaceId", "minimaxGroupId",
  "codexManagedAccounts", "activeCodexManagedAccountId", "activeCodexManagedAccountIdsByRuntime",
  "claudeManagedAccounts", "activeClaudeManagedAccountId",
  "githubProjects", "workspaceDirHistory", "defaultRepoSelection", "defaultLinearTeamSelection",
  "activeRuntimeEnvironmentId", "machineName", "androidSdkPath", "mobileEmulatorDefaultDeviceUdid",
  "mobilePairingCustomAddress", "mobilePairingCustomAddresses",
  "devPluginPaths", "pluginConsents", "floatingTerminalTrustedCwds"
]'

command -v jq >/dev/null 2>&1 || { echo "jq not found — brew install jq"; exit 1; }
command -v sqlite3 >/dev/null 2>&1 || { echo "sqlite3 not found"; exit 1; }

profile_db() {
  profile=$(jq -r '.activeProfileId // "local-default"' "$ORCA_DIR/orca-profile-index.json" 2>/dev/null || echo local-default)
  db="$ORCA_DIR/profiles/$profile/profile-state.db"
  [ -f "$db" ] || { echo "No Orca profile at $db — launch Orca once, quit it, then re-run."; exit 1; }
  echo "$db"
}

orca_running() {
  pgrep -f '^/Applications/Orca.app/Contents/MacOS/Orca$' >/dev/null 2>&1
}

cmd_export() {
  db=$(profile_db)
  # Plain reads are safe while Orca runs (the store is in WAL mode).
  sqlite3 "$db" "select payload from profile_state_documents where domain='settings'" \
    | jq --argjson drop "$DROP_KEYS" --arg home "$HOME" '
        with_entries(select(.key as $k | $drop | index($k) | not))
        | .workspaceDir |= (if type == "string" and startswith($home) then "~" + .[($home|length):] else . end)
        | .voice |= (if type == "object" then del(.microphoneDeviceId, .microphoneDeviceLabel, .modelsDir) else . end)
      ' > "$SNAPSHOT.tmp"
  mv "$SNAPSHOT.tmp" "$SNAPSHOT"
  echo "Wrote $(jq 'length' "$SNAPSHOT") settings to $SNAPSHOT"
}

cmd_apply() {
  [ -f "$SNAPSHOT" ] || { echo "No snapshot at $SNAPSHOT"; exit 1; }
  orca_running && { echo "Quit Orca first — it would overwrite the change on exit."; exit 1; }
  db=$(profile_db)

  backup="$db.dotfiles-backup.$(date +%Y%m%d%H%M%S)"
  sqlite3 "$db" ".backup '$backup'"
  echo "Backed up profile DB to $backup"

  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  # Current settings, overlaid with the snapshot. -j: Orca hashes the exact
  # compact payload bytes, so there must be no trailing newline.
  sqlite3 "$db" "select payload from profile_state_documents where domain='settings'" \
    | jq -cj --slurpfile snap "$SNAPSHOT" --arg home "$HOME" '
        . * ($snap[0] | .workspaceDir |= (if type == "string" and startswith("~/") then $home + .[1:] else . end))
      ' > "$tmp"
  hash=$(shasum -a 256 "$tmp" | cut -d' ' -f1)
  now=$(($(date +%s) * 1000))

  # Each document's revision is the store-wide counter at the time it was written.
  sqlite3 "$db" <<SQL
BEGIN;
UPDATE profile_state_meta SET value = CAST(value AS INTEGER) + 1 WHERE key = 'revision';
UPDATE profile_state_documents
   SET payload = CAST(readfile('$tmp') AS TEXT),
       content_hash = '$hash',
       revision = (SELECT CAST(value AS INTEGER) FROM profile_state_meta WHERE key = 'revision'),
       updated_at = $now
 WHERE domain = 'settings';
COMMIT;
SQL
  echo "Applied $(jq 'length' "$SNAPSHOT") settings. Start Orca to pick them up."
}

case "$1" in
  export) cmd_export ;;
  apply) cmd_apply ;;
  *) echo "Usage: sh $0 export|apply"; exit 1 ;;
esac
