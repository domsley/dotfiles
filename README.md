## Introduction

These are my personal dotfiles — tailored for my workflow and system.  
Feel free to **steal**, **modify**, and use them however you like.



Requirements:

something for screenhots
something for colorpick
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

## Package Installation

> Arch Linux only

Install system dependencies with:

```bash
./bin/packages.sh
```

Helpful flags:
- `--dry-run` prints the commands without running them.
- `--aur-only` or `--pacman-only` limit what gets installed.
- `--list` shows the tracked package lists.

The script also ensures external dependencies are cloned, e.g. `~/.tmux/plugins/tpm`.
