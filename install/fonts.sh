#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../fonts && pwd)"
DEST_DIR="${HOME}/.local/share/fonts"

# Ensure source exists and has fonts
if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source fonts directory not found: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
# Copy (preserve timestamps/permissions); quotes handle spaces
cp -R "$SRC_DIR"/. "$DEST_DIR"/

# Rebuild font cache (Linux)
if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -fv "$DEST_DIR"
else
  echo "fc-cache not found." >&2
fi

echo "Fonts installed to: $DEST_DIR"

