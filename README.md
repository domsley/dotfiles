## TODO

### General Setup
- [ ] Automate the installation of **HyprPanel**, ideally as part of a unified script for setting up a fresh Arch Linux environment.
- [ ] Automate the installation of **tmux plugins** using TPM (Tmux Plugin Manager).
- [ ] Identify a more minimal and reliable solution for **line-in audio monitoring**, currently handled via `qpwgraph`.
- [ ] Troubleshoot and resolve issues with **games crashing or misbehaving in fullscreen** under Hyprland — potentially related to tiling or window rules.
- [ ] Implement **Vim-like motion or modal control** in Hyprland (consider tools like `ydotool`, `hyprkeys`, etc.).
- [ ] Integrate a lightweight, **local AI assistant** into **Neovim** for code completion (e.g., `llm.nvim`, `ollama`, or `llama.cpp`).
- [ ] Write a brief **post-install guide for GPU driver setup**, with separate instructions for Nvidia and AMD systems.
- [ ] Add a **final setup message** at the end of the install script, listing any remaining manual steps.
- [ ] Include a **wallpaper directory** and link it to the appropriate configuration location.
- [ ] Install and refine the **Rofi configuration**.
- [ ] Install **swww** for managing wallpapers.
- [ ] Ensure a method exists to **fully reload all Hyprland components** — HyprPanel currently fails to reload cleanly.
- [ ] Develop a **HyprPanel module** to display the current keyboard layout.
- [ ] Add a keybinding to toggle **inner/outer window gaps** dynamically.
- [ ] Review and integrate tools like **MangoHud**, **GameScope**, **GameMode**, and others — [Reference](https://www.youtube.com/watch?v=5mn6xHCxTp4).
- [ ] Create two setup scripts: one **full setup** for a complete Arch install, and one **minimal setup** focused on development tools only.
- [ ] Enable **system-wide dark mode**.
- [ ] Set **Num Lock** to be disabled by default.

### Base Development Tools
- [ ] Install **base-devel** and **Linux headers** to enable building software from source.
- [ ] Install **Rust** and **Cargo**.
- [ ] Install and configure **Oh My Zsh**, and set **Zsh** as the default shell.
- [ ] Install **yay** (AUR helper) and verify it functions properly.

### Essential Applications
- [ ] Install **1Password**.
- [ ] Install **Remmina** (remote desktop client).
- [ ] Install **JetBrains Toolbox** (used for large projects like Unreal Engine 5).
- [ ] Install **Syncthing** for file synchronization.
- [ ] Install **Obsidian** for note-taking and knowledge management.
- [ ] Install **Blender** for 3D modeling and animation.
- [ ] Install **Kitty** (GPU-accelerated terminal emulator).
- [ ] Install **Docker** and **Docker Compose**.
- [ ] Install **Timeshift** and enable scheduled backups via **cron**.
- [ ] Choose and install a default browser — either **Zen** or **Firefox** (currently evaluating Zen).
- [ ] Optionally install **LibreOffice** as a fallback office suite.
- [ ] Install and configure **KVM** — ensure virtualization is supported and enabled in BIOS.

### Applications to Autostart
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


### Guide
[NVIDIA Drivers](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide)
