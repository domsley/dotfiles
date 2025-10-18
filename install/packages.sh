#!/usr/bin/env bash
set -euo pipefail

# Packages installed from the official repositories via pacman
declare -a PACMAN_PACKAGES=(
  archlinux-xdg-menu
  base-devel
  hyprland-protocols
  hyprlang
  hyprutils
  hyprwayland-scanner
  libdrm
  sdbus-cpp
  wayland-protocols
  xdg-desktop-portal-hyprland
  blender
  cronie
  dunst
  git
  hyprland
  hyprlock
  hyprpicker
  hyprshot
  kitty
  neovim
  noto-fonts
  pipewire
  wiremix
  pamixer
  blueberry
  qt5-wayland
  qt6-wayland
  ranger
  remmina
  tmux
  unzip
  waybar
  wget
  wl-clipboard
  zsh
  lazygit
  lazydocker
  btop
  mako
  fastfetch
  impala
)

# Packages installed from the AUR via yay
declare -a AUR_PACKAGES=(
  qpwgraph
  walker
  elephant
  elephant-desktopapplications
)

# Repositories that must be cloned to specific locations
# Format: "<git-url>|<destination-path>"
declare -a GIT_REPOSITORIES=(
  "https://github.com/tmux-plugins/tpm|$HOME/.tmux/plugins/tpm"
)

declare -a CLEANUP_DIRS=()

cleanup() {
  local dir
  for dir in "${CLEANUP_DIRS[@]}"; do
    [[ -d "$dir" ]] && rm -rf "$dir"
  done
}

trap cleanup EXIT

usage() {
  cat <<'EOF'
Usage: bin/packages.sh [options]

Install the packages needed for this dotfiles setup on Arch Linux.

Options:
  --pacman-only    Install only official repository packages.
  --aur-only       Install only AUR packages.
  --skip-sync      Do not run a full system upgrade before installing packages.
  --dry-run        Show the actions that would be taken without executing them.
  --list           Print the package lists and exit.
  -h, --help       Show this help message.
EOF
}

log() {
  local level="$1"
  shift
  printf '[%s] %s\n' "$level" "$*"
}

log_info() { log INFO "$@"; }
log_warn() { log WARN "$@"; }
log_error() { log ERROR "$@" >&2; }

fail() {
  log_error "$@"
  exit 1
}

run_cmd() {
  if ((DRY_RUN)); then
    printf '[DRY] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

print_package_list() {
  local title="$1"
  shift
  local -n ref="$1"
  printf '%s:\n' "$title"
  if ((${#ref[@]} == 0)); then
    printf '  (none)\n'
    return
  fi
  for pkg in "${ref[@]}"; do
    printf '  %s\n' "$pkg"
  done
}

install_build_tools() {
  local -a build_tools=(base-devel git)
  log_info "Ensuring build tools are present for AUR helpers."
  run_cmd sudo pacman -S --needed --noconfirm "${build_tools[@]}"
}

install_pacman_packages() {
  ((${#PACMAN_PACKAGES[@]})) || {
    log_info "No pacman packages defined; skipping."
    return
  }

  local -a args=(-S "--needed" "--noconfirm")
  if ((SYNC_SYSTEM)); then
    args=(-Syu "--needed" "--noconfirm")
  fi

  log_info "Installing ${#PACMAN_PACKAGES[@]} packages from the official repositories."
  run_cmd sudo pacman "${args[@]}" "${PACMAN_PACKAGES[@]}"
}

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  log_info "yay not found; installing from the AUR."

  install_build_tools

  if ((DRY_RUN)); then
    printf '[DRY] git clone https://aur.archlinux.org/yay.git <temp>\n'
    printf '[DRY] (cd <temp>/yay && makepkg -si --needed --noconfirm)\n'
    return
  fi

  local temp_dir
  temp_dir="$(mktemp -d)"
  CLEANUP_DIRS+=("$temp_dir")

  git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"
  (
    cd "$temp_dir/yay"
    makepkg -si --needed --noconfirm
  )

  rm -rf "$temp_dir"
}

ensure_git_available() {
  if command -v git >/dev/null 2>&1; then
    return
  fi
  log_info "git not detected; installing build tools."
  install_build_tools
}

resolve_path() {
  local path="$1"
  if [[ "$path" == "~/"* ]]; then
    printf '%s/%s' "$HOME" "${path#~/}"
  elif [[ "$path" == "~" ]]; then
    printf '%s' "$HOME"
  else
    printf '%s' "$path"
  fi
}

install_git_repositories() {
  ((${#GIT_REPOSITORIES[@]})) || {
    log_info "No git repositories defined; skipping."
    return
  }

  ensure_git_available

  log_info "Ensuring git repositories are cloned."

  local entry repo dest raw_dest parent
  for entry in "${GIT_REPOSITORIES[@]}"; do
    IFS='|' read -r repo raw_dest <<<"$entry"
    if [[ -z "$repo" || -z "$raw_dest" ]]; then
      log_warn "Skipping malformed repository entry: $entry"
      continue
    fi
    dest="$(resolve_path "$raw_dest")"
    parent="$(dirname "$dest")"

    if [[ -d "$dest/.git" ]]; then
      log_info "Updating repository in $dest."
      run_cmd git -C "$dest" pull --ff-only
      continue
    fi

    if [[ -d "$dest" && ! -d "$dest/.git" ]]; then
      log_warn "Directory exists without git metadata; skipping clone for $dest."
      continue
    fi

    log_info "Cloning $repo into $dest."
    run_cmd mkdir -p "$parent"
    run_cmd git clone "$repo" "$dest"
  done
}

install_aur_packages() {
  ((${#AUR_PACKAGES[@]})) || {
    log_info "No AUR packages defined; skipping."
    return
  }

  install_yay

  log_info "Installing ${#AUR_PACKAGES[@]} packages from the AUR."
  run_cmd yay -S --needed --noconfirm --answerclean None --answerdiff None "${AUR_PACKAGES[@]}"
}

install_oh_my_zsh_and_plugins() {
  local ohmyzsh_dir="${ZSH:-$HOME/.oh-my-zsh}"
  if [[ -d "$ohmyzsh_dir" ]]; then
    log_info "oh-my-zsh already present at $ohmyzsh_dir; skipping install."
  else
    log_info "Installing oh-my-zsh."
    if ((DRY_RUN)); then
      printf '[DRY] INSTALL oh-my-zsh via official script\n'
    else
      run_cmd env RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    fi
  fi

  log_info "Ensuring oh-my-zsh plugins are installed."
  local zsh_custom="${ZSH_CUSTOM:-$ohmyzsh_dir/custom}"
  local plugins_dir="$zsh_custom/plugins"
  run_cmd mkdir -p "$plugins_dir"

  declare -A zsh_plugin_repos=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
    [zsh-completions]="https://github.com/zsh-users/zsh-completions.git"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-z]="https://github.com/agkozak/zsh-z.git"
  )

  local plugin repo target
  for plugin in "${!zsh_plugin_repos[@]}"; do
    repo="${zsh_plugin_repos[$plugin]}"
    target="$plugins_dir/$plugin"

    if [[ -d "$target/.git" ]]; then
      log_info "Updating $plugin plugin."
      run_cmd git -C "$target" pull --ff-only
      continue
    fi

    if [[ -d "$target" ]]; then
      log_warn "Directory exists for $plugin but is not a git repository; skipping."
      continue
    fi

    log_info "Cloning $plugin plugin."
    run_cmd git clone "$repo" "$target"
  done
}

main() {
  PACMAN_ENABLED=1
  AUR_ENABLED=1
  SYNC_SYSTEM=1
  DRY_RUN=0
  LIST_ONLY=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --pacman-only)
      AUR_ENABLED=0
      ;;
    --aur-only)
      PACMAN_ENABLED=0
      ;;
    --skip-sync)
      SYNC_SYSTEM=0
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    --list)
      LIST_ONLY=1
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage
      fail "Unknown option: $1"
      ;;
    esac
    shift
  done

  ((PACMAN_ENABLED || AUR_ENABLED)) || fail "Nothing to do; both pacman and AUR installs disabled."

  if ! command -v pacman >/dev/null 2>&1; then
    fail "pacman not found. This script is intended for Arch Linux."
  fi

  if ((LIST_ONLY)); then
    ((PACMAN_ENABLED)) && print_package_list "pacman packages" PACMAN_PACKAGES
    ((AUR_ENABLED)) && print_package_list "AUR packages" AUR_PACKAGES
    exit 0
  fi

  install_oh_my_zsh_and_plugins

  log_info "Starting package installation."

  if ((PACMAN_ENABLED)); then
    install_pacman_packages
  else
    log_info "Skipping pacman packages."
  fi

  if ((AUR_ENABLED)); then
    install_aur_packages
  else
    log_info "Skipping AUR packages."
  fi

  install_git_repositories

  log_info "Package installation complete."
}

main "$@"
