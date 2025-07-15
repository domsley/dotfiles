## TODO

### General Setup
- [ ] Automate the installation of **HyprPanel**, ideally as part of a full script to auto-install all essential software for a fresh Arch Linux setup.
- [ ] Automate the installation of **tmux plugins** using TPM (Tmux Plugin Manager).
- [ ] Find a more minimal and reliable solution for **line-in audio monitoring**, currently done via `qpwgraph`.
- [ ] Resolve issues with **games crashing or misbehaving in fullscreen** under Hyprland — likely related to tiling/window rules.
- [ ] Add **Vim-like motions** or modal control to Hyprland (e.g., via `ydotool`, `hyprkeys`, or similar).
- [ ] Integrate a lightweight, **local AI agent** into **Neovim** for code completion and assistance (e.g., using `llm.nvim`, `ollama`, or `llama.cpp`).
- [ ] Create a **simple post-install tutorial** or notes for **GPU driver installation** — one for Nvidia, and one for AMD (based on your personal setup).
- [ ] Display a **final setup message** after script execution, listing manual steps required post-installation.

### Base Development Tools
- [ ] Install **base-devel** and **Linux headers** to support building from source.
- [ ] Install **Rust** and **Cargo**.
- [ ] Install and configure **Oh My Zsh**, and set **Zsh** as the default shell.
- [ ] Install **yay** (AUR helper) and ensure it’s working properly.

### Essential Applications
- [ ] Install **1Password**.
- [ ] Install **Remmina** (remote desktop client).
- [ ] Install **JetBrains Toolbox** (used occasionally for larger or source-heavy projects like UE5).
- [ ] Install **Syncthing**.
- [ ] Install **Obsidian** (for note-taking).
- [ ] Install **Blender** (3D modeling/animation).
- [ ] Install **Kitty** (GPU-based terminal emulator).
- [ ] Install **Docker** and **Docker Compose**.
- [ ] Install **Timeshift** and ensure **CRON-based scheduled backups** are enabled.
- [ ] Decide on a default browser — either **Zen** or **Firefox** (currently testing Zen, undecided).
- [ ] Install **LibreOffice** (optional but useful fallback).
- [ ] Install and configure **KVM** — ensure hardware virtualization is enabled in BIOS and supported by CPU.


### Prerequisites:
- zsh
- [oh-my-zsh](https://ohmyz.sh/#install)
- Neovim (possibly nightly build)

### Setup

Run setup or link configs manually:

```shell
sh setup.sh
```

### Tmux

In tmux session hit 'prefix + I' to install tpm plugins.
