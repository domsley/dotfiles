#!/bin/bash

set -e  # Exit immediately if any command fails

echo "WARNING: This script will overwrite existing configuration files and folders."
echo "Check the setup script first!"
echo "Use this at your own risk."

read -p "Do you wish to proceed? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Aborted by user."
  exit 1
fi

USE_HTTPS=true
FULL_SETUP=true

# Parse arguments
for arg in "$@"; do
  case $arg in
    --ssh)
      USE_HTTPS=false
      ;;
    --minimal)
      FULL_SETUP=false
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--ssh] [--minimal]"
      exit 1
      ;;
  esac
done

create_clean_symlink() {
  local source=$1
  local target=$2

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Removing existing: $target"
    rm -rf "$target"
  fi

  ln -s "$source" "$target"
  echo "Linked $target → $source"
}

ensure_service_active() {
  local service_name="$1"

  echo "Ensuring $service_name is enabled and running..."

  if systemctl list-unit-files | grep -q "^${service_name}"; then
    if ! systemctl is-enabled --quiet "$service_name"; then
      echo "Enabling $service_name..."
      sudo systemctl enable "$service_name"
    else
      echo "$service_name is already enabled."
    fi

    if ! systemctl is-active --quiet "$service_name"; then
      echo "🔄 Starting $service_name..."
      sudo systemctl start "$service_name"
    else
      echo "$service_name is already running."
    fi
  else
    echo "$service_name not found. Make sure it's installed."
  fi
}

# If full setup is selected, run the package installation script
if $FULL_SETUP; then
  if [ -f "$(pwd)/scripts/packages.sh" ]; then
    echo "Running package installation script..."
    bash "$(pwd)/scripts/packages.sh"
  else
    echo "Error: scripts/packages.sh not found."
    exit 1
  fi

  # Cronie for timeshift :3
  ensure_service_active cronie.service

fi

# Create necessary config directories
echo "Creating config directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/hypr
mkdir -p ~/.config/ranger
mkdir -p ~/.config/hyprpanel
mkdir -p ~/.tmux/plugins
mkdir -p ~/.oh-my-zsh/custom/plugins

# Symlink dotfiles
echo "Creating symlinks for dotfiles..."
create_clean_symlink "$(pwd)/tmux.conf" ~/.tmux.conf
create_clean_symlink "$(pwd)/zshrc" ~/.zshrc
create_clean_symlink "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf
create_clean_symlink "$(pwd)/hypr" ~/.config/hypr
create_clean_symlink "$(pwd)/waybar" ~/.config/waybar
create_clean_symlink "$(pwd)/ranger" ~/.config/ranger
create_clean_symlink "$(pwd)/dunst" ~/.config/dunst
create_clean_symlink "$(pwd)/rofi" ~/.config/rofi
create_clean_symlink "$(pwd)/scripts" ~/.config/custom_scripts

# TPM (Tmux Plugin Manager)
echo "Installing Tmux Plugin Manager (TPM)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "TPM already installed."
fi

# ZSH Plugins
echo "Installing ZSH plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

declare -A plugins=(
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  [zsh-z]="https://github.com/agkozak/zsh-z"
)

for name in "${!plugins[@]}"; do
  target_dir="$PLUGINS_DIR/$name"
  if [ ! -d "$target_dir" ]; then
    git clone "${plugins[$name]}" "$target_dir"
  fi
done

# Remove existing nvim config before cloning
if [ -d ~/.config/nvim ]; then
  echo "Removing existing ~/.config/nvim..."
  rm -rf ~/.config/nvim
fi

# Clone Neovim config and optionally wallpapers
if $USE_HTTPS; then
  echo "Cloning Neovim config with HTTPS..."
  git clone https://github.com/domsley/nvim.git ~/.config/nvim

  echo "Skipping personal wallpapers repository (requires SSH)."
  echo "Note: Some scripts may expect wallpapers in: ~/Pictures/wallpapers"
  mkdir -p ~/Pictures/wallpapers
  echo "You can add your own wallpapers manually to that folder."
else
  echo "Cloning Neovim config with SSH..."
  git clone git@github.com:domsley/nvim.git ~/.config/nvim

  read -p "Do you want to clone the wallpapers repository? (This will delete the existing ~/Pictures/wallpapers directory) [y/N]: " include_wallpapers

  if [[ "$include_wallpapers" =~ ^[Yy]$ ]]; then
    if [ -d ~/Pictures/wallpapers ]; then
      echo "Removing existing ~/Pictures/wallpapers..."
      rm -rf ~/Pictures/wallpapers
    fi
    echo "Cloning wallpapers with SSH..."
    git clone git@github.com:domsley/wallpapers.git ~/Pictures/wallpapers
  else
    echo "Skipping wallpaper repository download."
  fi
fi

echo "Setup complete!"

if ! $FULL_SETUP; then
  echo "----------------------------------------------------------------------------------"
  echo ""
  echo "Minimal setup selected."
  echo "You may need to manually install the following packages before using this config:"
  echo "  - zsh"
  echo "  - tmux"
  echo "  - git"
  echo "  - neovim"
  echo ""
  echo "Install them using your system's package manager (e.g. apt, pacman, dnf, brew)."
  echo ""
  echo "----------------------------------------------------------------------------------"
fi
