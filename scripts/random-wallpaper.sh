#!/bin/bash
WALLPAPERS_DIR="$HOME/Pictures/wallpapers"

# Only choose from known image formats
IMAGE=$(find "$WALLPAPERS_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)

# Ensure an image was found
if [ -z "$IMAGE" ]; then
    echo "No valid wallpaper found."
    exit 1
fi

# Init swww if it's not already running
swww query &>/dev/null || swww init
swww img "$(find "$IMAGE" -type f | shuf -n 1)" --transition-fps 60 --transition-step 255 --transition-type any
