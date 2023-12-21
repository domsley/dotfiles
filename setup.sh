#!bin/bash
ln -sf "$(pwd)/tmux/tmux.conf" ~/.tmux.conf
ln -sf "$(pwd)/oh-my-zsh/.zshrc" ~/.zshrc
ln -sf "$(pwd)/kitty" ~/.config
ln -sf "$(pwd)/.wezterm.lua" ~/.config

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
