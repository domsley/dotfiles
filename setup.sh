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

USE_HTTPS=false
FULL_SETUP=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --https)
      USE_HTTPS=true
      ;;
    --full-setup)
      FULL_SETUP=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--https] [--full-setup]"
      exit 1
      ;;
  esac
done

# Placeholder for full setup, This will install everything on Fresh Arch
if $FULL_SETUP; then
  echo "Full setup selected — placeholder."
fi

# Create necessary config directories
echo "Creating config directories..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/hypr
mkdir -p ~/.config/hyprpanel
mkdir -p ~/.tmux/plugins
mkdir -p ~/.oh-my-zsh/custom/plugins

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

# Symlink dotfiles
echo "Creating symlinks for dotfiles..."
create_clean_symlink "$(pwd)/tmux.conf" ~/.tmux.conf
create_clean_symlink "$(pwd)/zshrc" ~/.zshrc
# create_clean_symlink "$(pwd)/wezterm.lua" ~/.wezterm.lua
create_clean_symlink "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf
create_clean_symlink "$(pwd)/hypr" ~/.config/hypr
create_clean_symlink "$(pwd)/hyprpanel" ~/.config/hyprpanel
create_clean_symlink "$(pwd)/waybar" ~/.config/waybar
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

# Choose protocol based on flag
if $USE_HTTPS; then
  echo "Cloning nvim config with HTTPS..."
  git clone https://github.com/domsley/nvim.git ~/.config/nvim
  echo "Skipping wallpapers (only cloned via SSH)."
else
  echo "Cloning nvim config with SSH..."
  git clone git@github.com:domsley/nvim.git ~/.config/nvim

  read -p "Do you want to include the wallpaper repository for download? [y/N]: " include_wallpapers
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
