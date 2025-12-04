# NixOS Hyprland Configuration

<div align="center">
  <img src="Nixos-logo.png" alt="NixOS Logo" width="200"/>
</div>

## NixOS 26.05 (Yarara)

## Overview

Custom NixOS configuration with Hyprland window manager, optimized for development productivity.

## Key Features

**Desktop Environment**
- Hyprland (Wayland compositor)
- SDDM with Catppuccin Mocha theme
- Waybar status bar
- Rofi launcher

**Development Stack**
- Languages: Node.js 22, Python 3, Rust, Go, Bun
- Editors: Cursor, Zed Editor, VS Code, Neovim
- Terminals: Kitty, Ghostty
- Shell: Zsh with Powerlevel10k

**System Configuration**
- Kernel: Linux 6.6
- Boot: systemd-boot with EFI
- Audio: PipeWire
- Bluetooth: Blueman
- Power: TLP optimization
- Docker support

**Applications**
- Browsers: Google Chrome (Wayland)
- Communication: Discord
- Media: VLC, Spotify
- Productivity: Obsidian, LibreOffice
- File Manager: Thunar

## Theming

- Theme: Catppuccin Mocha (pink accents)
- Icons: Papirus
- Cursors: Catppuccin Mocha Pink
- Fonts: JetBrains Mono Nerd Font, Fira Code, Hack
- GTK: Catppuccin GTK theme

## Images

<div align="center">
  <img src="images/btop.png" alt="btop" width="300"/>
  <img src="images/fastfetch.png" alt="fastfetch" width="300"/>
  <img src="images/screen-shot.png" alt="screen-shot" width="300"/>
</div>

## System Details

**Locale & Timezone**
- Timezone: Asia/Kolkata
- Locale: en_IN (English India)

**Security**
- Polkit authentication agent
- GNOME Keyring for credentials
- OpenSSH server enabled
- NetworkManager integration

**Package Management**
- Nix Flakes for reproducible builds
- Unfree packages allowed
- Flatpak support
- Docker support

**Performance**
- TLP battery optimization
- PipeWire low-latency audio
- Wayland display protocol
- Intel integrated graphics support

## Notes

- Designed for x86_64-linux systems
- Hyprland only (no other desktop environments)
- Development-focused with comprehensive tooling
- Catppuccin color scheme
- Wayland-first approach

## Credits

### Configuration Sources
- **Hyprland Configuration**: Adapted from [snxhasish's dotfiles](https://github.com/snxhasish/nixos-dotfiles)
  - `hyprland.conf` - Window manager configuration and keybindings
  
- **Waybar**: Based on [snxhasish's setup](https://github.com/snxhasish/nixos-dotfiles)
  - `config.jsonc` - Status bar modules and layout
  - `style.css` - Catppuccin Mocha theme styling
  
- **Kitty Terminal**: Initial config from [snxhasish](https://github.com/snxhasish/nixos-dotfiles)
  - Basic transparency and blur settings

All configurations have been customized for personal use.

---


