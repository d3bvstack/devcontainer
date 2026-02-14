#!/usr/bin/env bash
# install-devcontainer.sh — copy this repo's .devcontainer into a target project
# Usage: install-devcontainer.sh [TARGET_DIR] [--force] [--submodule]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || SCRIPT_DIR=""
REPO_URL="https://github.com/d3bvstack/devcontainer.git"

TARGET_DIR="."
FORCE=0
SUBMODULE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE=1; shift ;;
    --submodule) SUBMODULE=1; shift ;;
    -h|--help) echo "Usage: $0 [TARGET_DIR] [--force] [--submodule]"; exit 0 ;;
    *)
      if [[ "$TARGET_DIR" == "." ]]; then TARGET_DIR="$1"; else echo "Unknown arg: $1"; exit 1; fi
      shift
      ;;
  esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 2
fi

if [[ -e "$TARGET_DIR/.devcontainer" && $FORCE -ne 1 && $SUBMODULE -ne 1 ]]; then
  echo "A .devcontainer already exists in $TARGET_DIR — use --force to overwrite or --submodule to add as submodule." >&2
  exit 3
fi

# If caller requests a submodule, add remote submodule and exit
if [[ $SUBMODULE -eq 1 ]]; then
  if [[ ! -d "$TARGET_DIR/.git" ]]; then
    echo "Target is not a git repository — initialize one or omit --submodule." >&2
    exit 4
  fi
  (cd "$TARGET_DIR" && git submodule add "$REPO_URL" .devcontainer)
  echo "Added .devcontainer as git submodule from $REPO_URL"
  exit 0
fi

# Copy from local repo if available, otherwise download archive from GitHub
TMPDIR=""
if [[ -d "$SCRIPT_DIR/.devcontainer" ]]; then
  echo "Copying .devcontainer from local repository -> $TARGET_DIR/.devcontainer"
  rm -rf "$TARGET_DIR/.devcontainer.tmp"
  cp -a "$SCRIPT_DIR/.devcontainer" "$TARGET_DIR/.devcontainer.tmp"
else
  echo "Local .devcontainer not found — downloading from $REPO_URL (master)"
  TMPDIR="$(mktemp -d)"
  curl -fsSL "https://github.com/d3bvstack/devcontainer/archive/refs/heads/master.tar.gz" | tar -xzf - -C "$TMPDIR"
  # expected folder: devcontainer-master
  SRC="$TMPDIR/devcontainer-master/.devcontainer"
  if [[ ! -d "$SRC" ]]; then echo "Downloaded archive missing .devcontainer" >&2; exit 5; fi
  cp -a "$SRC" "$TARGET_DIR/.devcontainer.tmp"
fi

# Move into place (atomic-ish)
rm -rf "$TARGET_DIR/.devcontainer.old" || true
mv "$TARGET_DIR/.devcontainer" "$TARGET_DIR/.devcontainer.old" 2>/dev/null || true
mv "$TARGET_DIR/.devcontainer.tmp" "$TARGET_DIR/.devcontainer"

echo ".devcontainer installed to $TARGET_DIR/.devcontainer"

# Clean up
if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then rm -rf "$TMPDIR"; fi
exit 0
