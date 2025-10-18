if [ -d "$HOME/Pictures/wallpapers/.git" ]; then
  git -C "$HOME/Pictures/wallpapers" pull --ff-only
else
  git clone git@github.com:domsley/wallpapers.git "$HOME/Pictures/wallpapers"
fi
