## Introduction

These are my personal dotfiles — tailored for my workflow and system.  
Feel free to **steal**, **modify**, and use them however you like.

>  **Note:**  
> The setup script may install packages you **don’t need**, or in rare cases, packages that could **break things** on your system.  
> Use with caution and **review the script before running it**.


### Prerequisites:
- zsh
- [oh-my-zsh](https://ohmyz.sh/#install)
- Neovim (possibly nightly build)
- Arch Based Distro

### Setup

This repository includes a `setup.sh` script to automate the installation and configuration of your dotfiles and development environment.

#### Default Behavior

By default, running the script will:

- Install required packages (via `scripts/packages.sh`)
- Create all necessary config directories
- Symlink dotfiles into `~/.config` and your home directory
- Install ZSH and Tmux plugins
- Clone the Neovim config using **HTTPS**

#### How to Run

```bash
./setup.sh
```

You’ll be prompted to confirm before proceeding. The script is safe to run on fresh or existing systems (it removes and replaces conflicting files).


#### Optional Arguments
You can customize the setup with the following arguments:

| Argument                | Description                                                                    | 
|-------------------------|--------------------------------------------------------------------------------|
| --ssh                   |  Clone repositories using SSH instead of HTTPS.                                |
| --minimal               |  Skip the full system setup (no packages installed). Only dotfiles are linked. |



### Tmux

In tmux session hit 'prefix + I' to install tpm plugins.


### Shortcuts (Hyprland)

| Shortcut                | Action/Command                                 | Description                                 |
|-------------------------|------------------------------------------------|---------------------------------------------|
| SUPER + Return          | $terminal (kitty)                              | Open terminal                               |
| SUPER + C               | killactive                                     | Close active window                         |
| SUPER + M               | exit                                           | Logout/exit Hyprland                        |
| SUPER + E               | $fileManager (dolphin)                         | Open file manager                           |
| SUPER + V               | togglefloating                                 | Toggle floating mode for window             |
| SUPER + R               | $menu (rofi -show drun)                        | Open app launcher (rofi)                    |
| SUPER + P               | pseudo                                         | Toggle pseudotile (dwindle layout)          |
| SUPER + J               | togglesplit                                    | Toggle split orientation (dwindle layout)   |
| SUPER + SHIFT + C       | sleep 0.5 && hyprpicker -a                     | Color picker                                |
| SUPER + SHIFT + R       | hyprpanel -q; hyprpanel && swww-daemon         | Restart Hyprpanel and swww-daemon           |
| SUPER + Arrow Keys      | movefocus (l/r/u/d)                            | Move focus between windows                  |
| SUPER + [1-9,0]         | workspace [1-10]                               | Switch to workspace                         |
| SUPER + SHIFT + [1-9,0] | movetoworkspace [1-10]                         | Move window to workspace                    |
| SUPER + mouse_down      | workspace e+1                                  | Next workspace (scroll down)                |
| SUPER + mouse_up        | workspace e-1                                  | Previous workspace (scroll up)              |
| SUPER + LMB             | movewindow                                     | Move window (drag with mouse)               |
| SUPER + RMB             | resizewindow                                   | Resize window (drag with mouse)             |
| XF86AudioRaiseVolume    | wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ | Raise volume                                |
| XF86AudioLowerVolume    | wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-      | Lower volume                                |
| XF86AudioMute           | wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle     | Mute/unmute audio output                    |
| XF86AudioMicMute        | wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle   | Mute/unmute microphone                      |
| XF86MonBrightnessUp     | brightnessctl -e4 -n2 set 5%+                  | Increase brightness                         |
| XF86MonBrightnessDown   | brightnessctl -e4 -n2 set 5%-                  | Decrease brightness                         |
| XF86AudioNext           | playerctl next                                 | Next media track                            |
| XF86AudioPause/Play     | playerctl play-pause                           | Play/pause media                            |
| XF86AudioPrev           | playerctl previous                             | Previous media track                        |
| SUPER + SHIFT + S       | hyprshot -m region --clipboard-only            | Screenshot selection to clipboard           |
| SUPER + F9              | random-wallpaper.sh                            | Set random wallpaper                        |

*SUPER = Windows key*

### Guide
[NVIDIA Drivers](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide)

---

## TODO

### General Setup
- [x] Automate the installation of **HyprPanel**, ideally as part of a unified script for setting up a fresh Arch Linux environment.
- [x] Automate the installation of **tmux plugins** using TPM (Tmux Plugin Manager).
- [ ] Identify a more minimal and reliable solution for **line-in audio monitoring**, currently handled via `qpwgraph`.
- Move some symlinks to full setup, minimal should have just one nessecary
- With minimal setup I should at least prompt what's needed to be installed since minimal setup should work on every distro in theory
- [x] Troubleshoot and resolve issues with **games crashing or misbehaving in fullscreen** under Hyprland — potentially related to tiling or window rules.
- [ ] Implement **Vim-like motion or modal control** in Hyprland (consider tools like `ydotool`, `hyprkeys`, etc.).
- [ ] Integrate a lightweight, **local AI assistant** into **Neovim** for code completion (e.g., `llm.nvim`, `ollama`, or `llama.cpp`).
- [ ] Write a brief **post-install guide for GPU driver setup**, with separate instructions for Nvidia and AMD systems.
- [ ] Add a **final setup message** at the end of the install script, listing any remaining manual steps.
- [-] Include a **wallpaper directory** and link it to the appropriate configuration location.
- [-] Install and refine the **Rofi configuration**.
- [-] Install **swww** for managing wallpapers.
- [ ] Ensure a method exists to **fully reload all Hyprland components** — HyprPanel currently fails to reload cleanly.
- [ ] Develop a **HyprPanel module** to display the current keyboard layout.
- [ ] Add a keybinding to toggle **inner/outer window gaps** dynamically.
- [ ] Review and integrate tools like **MangoHud**, **GameScope**, **GameMode**, and others — [Reference](https://www.youtube.com/watch?v=5mn6xHCxTp4).
- [ ] Create two setup scripts: one **full setup** for a complete Arch install, and one **minimal setup** focused on development tools only.
- [ ] Enable **system-wide dark mode**.
- [ ] Set **Num Lock** to be disabled by default.
- [x] Super + Shift + C = Color picker
- [x] Super + Shift + S = Screeshot Selection
- [ ] Tweak animation easing

### Base Development Tools
- [x] Install **base-devel** and **Linux headers** to enable building software from source.
- [ ] Install **Rust** and **Cargo**.
- [ ] Install and configure **Oh My Zsh**, and set **Zsh** as the default shell.
- [x] Install **yay** (AUR helper) and verify it functions properly.

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
