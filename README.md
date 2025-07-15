## TODO

### General Setup
- [ ] Automate the installation of **HyprPanel**, ideally as part of a script to auto-install all essential software for a fresh Arch Linux setup.
- [ ] Automate the installation of **tmux plugins** using TPM (Tmux Plugin Manager).
- [ ] Find a more minimal and reliable solution for **line-in audio monitoring**, currently handled via `qpwgraph`.
- [ ] Resolve issues with **games crashing or misbehaving in fullscreen** under Hyprland — likely related to tiling or window rules.
- [ ] Add **Vim-like motions** or modal control to Hyprland (e.g., using `ydotool`, `hyprkeys`, or similar tools).
- [ ] Integrate a lightweight, **local AI agent** into **Neovim** for code completion and assistance (e.g., using `llm.nvim`, `ollama`, or `llama.cpp`).
- [ ] Create a simple **post-install tutorial** or notes for **GPU driver installation** — one for Nvidia, and one for AMD (based on your setup).
- [ ] Display a **final setup message** after script execution, listing any manual steps required post-installation.
- [ ] Add a **wallpaper folder** and link it to the appropriate configuration path.
- [ ] Install and improve the **Rofi configuration**.
- [ ] Install **swww** for wallpaper management.
- [ ] Find a way to **fully reload all components** under Hyprland — currently, HyprPanel does not reload properly.

### Base Development Tools
- [ ] Install **base-devel** and **Linux headers** to support building from source.
- [ ] Install **Rust** and **Cargo**.
- [ ] Install and configure **Oh My Zsh**, and set **Zsh** as the default shell.
- [ ] Install **yay** (AUR helper) and ensure it's functioning correctly.

### Essential Applications
- [ ] Install **1Password**.
- [ ] Install **Remmina** (remote desktop client).
- [ ] Install **JetBrains Toolbox** (occasionally used for larger or source-heavy projects like UE5).
- [ ] Install **Syncthing**.
- [ ] Install **Obsidian** (for note-taking).
- [ ] Install **Blender** (3D modeling and animation).
- [ ] Install **Kitty** (GPU-accelerated terminal emulator).
- [ ] Install **Docker** and **Docker Compose**.
- [ ] Install **Timeshift** and enable **CRON-based scheduled backups**.
- [ ] Choose a default browser — either **Zen** or **Firefox** (currently testing Zen).
- [ ] Install **LibreOffice** (optional, but useful as a fallback).
- [ ] Install and configure **KVM** — ensure hardware virtualization is enabled in BIOS and supported by your CPU.

### Things to Autostart
- [ ] **Syncthing**
- [ ] **Timeshift**
- [ ] **Docker**


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
