#!/bin/bash

set -e  # Exit on error

echo "[INFO] Starting package installation..."

# Packages from official repositories
PACMAN_PACKAGES=(
    base-devel
    git
    zsh
    hyprland
    waybar
    hyprshot
    hyprpicker
    hyprlock
    ranger
    dunst
    pipewire
    libnotify
    archlinux-xdg-menu
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt6-wayland
    noto-fonts
    cronie
    rofi-wayland
    swww
    kitty
    neovim
    tmux
    wl-clipboard
    wget
    unzip
    remmina
    blender
    nwg-displays
    discord
    gamescope
)

# Packages from AUR
AUR_PACKAGES=(
  ags-hyprpanel-git
  cursor-bin
)

# Install official packages
echo "[INFO] Installing official packages with pacman..."
sudo pacman -Syu --noconfirm "${PACMAN_PACKAGES[@]}"

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "[INFO] yay not found, installing..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Install AUR packages
echo "[INFO] Installing AUR packages with yay..."
yay -S --noconfirm "${AUR_PACKAGES[@]}"

echo "[SUCCESS] All packages installed successfully!"
