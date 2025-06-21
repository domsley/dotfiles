#!bin/bash
ln -sf "$(pwd)/tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/zshrc" ~/.zshrc
ln -sf "$(pwd)/wezterm.lua" ~/.wezterm.lua
ln -sf "$(pwd)/kitty.conf" ~/.config/kitty/kitty.conf

# TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ZSH Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z

# Font
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
cd SFMono-Nerd-Font-Ligaturized
mkdir -p ~/.local/share/fonts
cp *.otf ~/.local/share/fonts
fc-cache -f -v

# Neovim
# If no ssh key: https://github.com/domsley/nvim.git
git clone git@github.com:domsley/nvim.git ~/.config/nvim
