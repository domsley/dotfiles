#!/usr/bin/env bash
set -euo pipefail

# Absolute path to repository root
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Allow overriding backup root via DOTFILES_BACKUP_DIR, default to ~/.dotfiles_backup
BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles_backup}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR=""
MANIFEST_FILE=""

# Map repository paths to their desired targets
declare -A TARGETS=(
  ["bin"]="$HOME/.local/bin"
  ["nvim"]="$HOME/.config/nvim"
  ["hypr"]="$HOME/.config/hypr"
  ["rofi"]="$HOME/.config/rofi"
  ["kitty.conf"]="$HOME/.config/kitty/kitty.conf"
  ["tmux.conf"]="$HOME/.tmux.conf"
  ["waybar"]="$HOME/.config/waybar"
  ["mako"]="$HOME/.config/mako"
  ["zshrc"]="$HOME/.zshrc"
  ["chromium-flags.conf"]="$HOME/.config/chromium-flags.conf"
)

usage() {
  cat <<'EOF'
Usage: ./setup.sh [options]

Options:
  --restore [TIMESTAMP]  Restore files from the specified backup directory.
                         If TIMESTAMP is omitted, the most recent backup is used.
  --list-backups         List available backup directories.
  -h, --help             Show this help message.

Without options, the script creates symlinks for the dotfiles and backs up
existing files to a timestamped directory under $HOME/.dotfiles_backup.
EOF
}

ensure_backup_dir() {
  if [[ -z "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR"
    MANIFEST_FILE="$BACKUP_DIR/.manifest"
    : >"$MANIFEST_FILE"
    printf 'Backups will be stored in %s\n' "$BACKUP_DIR"
  fi
}

relative_target_path() {
  local target="$1"
  if [[ "$target" == "$HOME" ]]; then
    printf ''
  elif [[ "$target" == "$HOME/"* ]]; then
    printf '%s' "${target#$HOME/}"
  else
    printf '%s' "${target#/}"
  fi
}

record_backup() {
  local target="$1"
  local rel_path="$2"
  if [[ -n "$MANIFEST_FILE" ]]; then
    printf '%s|%s\n' "$target" "$rel_path" >>"$MANIFEST_FILE"
  fi
}

link_item() {
  local relative="$1"
  local target="$2"
  local source="$REPO_DIR/$relative"

  if [[ ! -e "$source" && ! -L "$source" ]]; then
    printf 'Skipping missing source: %s\n' "$source" >&2
    return 0
  fi

  if [[ -L "$target" ]]; then
    local existing
    existing="$(readlink "$target")"
    if [[ "$existing" == "$source" ]]; then
      printf 'Already linked: %s\n' "$target"
      return 0
    fi
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    ensure_backup_dir
    local rel_path
    rel_path="$(relative_target_path "$target")"
    local backup_path="$BACKUP_DIR/$rel_path"
    mkdir -p "$(dirname "$backup_path")"
    mv "$target" "$backup_path"
    record_backup "$target" "$rel_path"
    printf 'Backed up %s to %s\n' "$target" "$backup_path"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source"
}

list_backups() {
  if [[ ! -d "$BACKUP_ROOT" ]]; then
    printf 'No backups found in %s\n' "$BACKUP_ROOT"
    return
  fi

  local -a backups
  while IFS= read -r entry; do
    backups+=("$(basename "$entry")")
  done < <(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort)

  if [[ ${#backups[@]} -eq 0 ]]; then
    printf 'No backups found in %s\n' "$BACKUP_ROOT"
    return
  fi

  printf 'Available backups:\n'
  for dir in "${backups[@]}"; do
    printf '  %s\n' "$dir"
  done
}

resolve_backup_dir() {
  local wanted="$1"

  if [[ ! -d "$BACKUP_ROOT" ]]; then
    printf 'No backups found in %s\n' "$BACKUP_ROOT" >&2
    return 1
  fi

  if [[ -z "$wanted" || "$wanted" == "latest" ]]; then
    local latest
    latest="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort | tail -n1 || true)"
    if [[ -z "$latest" ]]; then
      printf 'No backups found in %s\n' "$BACKUP_ROOT" >&2
      return 1
    fi
    printf '%s\n' "$latest"
    return 0
  fi

  local candidate="$BACKUP_ROOT/$wanted"
  if [[ ! -d "$candidate" ]]; then
    printf 'Backup directory not found: %s\n' "$candidate" >&2
    return 1
  fi
  printf '%s\n' "$candidate"
}

restore_from_backup() {
  local backup_dir="$1"
  local manifest="$backup_dir/.manifest"

  if [[ ! -f "$manifest" ]]; then
    printf 'Manifest missing in %s; cannot restore safely.\n' "$backup_dir" >&2
    return 1
  fi

  while IFS='|' read -r target rel_path; do
    [[ -z "$target" ]] && continue
    local backup_path="$backup_dir/$rel_path"
    if [[ ! -e "$backup_path" && ! -L "$backup_path" ]]; then
      printf 'Skipping missing backup entry: %s\n' "$backup_path" >&2
      continue
    fi

    if [[ -L "$target" ]]; then
      local link_target
      link_target="$(readlink "$target")"
      if [[ "$link_target" == "$REPO_DIR/"* ]]; then
        rm "$target"
      else
        printf 'Skipping %s (symlink points to %s, not replacing).\n' "$target" "$link_target" >&2
        continue
      fi
    elif [[ -e "$target" ]]; then
      printf 'Skipping %s (file exists and is not a repo symlink).\n' "$target" >&2
      continue
    fi

    mkdir -p "$(dirname "$target")"
    cp -a "$backup_path" "$target"
    printf 'Restored %s from %s\n' "$target" "$backup_path"
  done <"$manifest"

  printf 'Restore complete from %s\n' "$backup_dir"
}

perform_linking() {
  # Link the direct mappings
  for relative in "${!TARGETS[@]}"; do
    link_item "$relative" "${TARGETS[$relative]}"
  done

  # Handle scripts: link executable scripts into ~/.local/bin
  local scripts_dir="$REPO_DIR/scripts"
  if [[ -d "$scripts_dir" ]]; then
    mkdir -p "$HOME/.local/bin"
    while IFS= read -r -d '' script; do
      chmod +x "$script"
      local base
      base="$(basename "$script")"
      link_item "scripts/$base" "$HOME/.local/bin/$base"
    done < <(find "$scripts_dir" -maxdepth 1 -type f -print0)
  fi

  printf 'Setup complete.\n'
}

MODE="link"
RESTORE_SPEC=""
LIST_FLAG=0

while [[ $# -gt 0 ]]; do
  case "$1" in
  --restore)
    MODE="restore"
    if [[ ${2-} && $2 != --* && $2 != -h ]]; then
      RESTORE_SPEC="$2"
      shift
    else
      RESTORE_SPEC="latest"
    fi
    ;;
  --list-backups)
    LIST_FLAG=1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    printf 'Unknown option: %s\n\n' "$1" >&2
    usage
    exit 1
    ;;
  esac
  shift
done

if ((LIST_FLAG)); then
  list_backups
  exit 0
fi

if [[ "$MODE" == "restore" ]]; then
  backup_dir="$(resolve_backup_dir "$RESTORE_SPEC")"
  restore_from_backup "$backup_dir"
  exit 0
fi

perform_linking
