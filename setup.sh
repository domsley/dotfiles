#!bin/bash

ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/zshrc" ~/.zshrc
# ln -sf "$(pwd)/wezterm.lua" ~/.wezterm.lua
ln -sf "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf
ln -sf "$(pwd)/hypr" ~/.config/hypr
ln -sf "$(pwd)/hyprpanel" ~/.config/hyprpanel

# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ZSH Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z

#TODO Install font [yes/no]
# Font
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
cd SFMono-Nerd-Font-Ligaturized
mkdir -p ~/.local/share/fonts
cp *.otf ~/.local/share/fonts
fc-cache -f -v


#TODO: Create argument for this
# Neovim
# Choose from [yes/no] do you have right to change nvim config?
# git clone https://github.com/domsley/nvim.git ~/.config/nvim
git clone git@github.com:domsley/nvim.git ~/.config/nvim

git clone git@github.com:domsley/wallpapers.git ~/Pictures/wallpapers
