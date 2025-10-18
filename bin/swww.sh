#!/bin/bash

# Start the swww daemon if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1  # Give it a moment to start
fi

# Set the wallpaper with transition
# swww img ~/Pictures/wallpapers/mac.jpg
