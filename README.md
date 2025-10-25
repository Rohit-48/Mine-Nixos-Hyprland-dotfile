# NixOS Hyprland Configuration

<div align="center">
  <img src="Nixos-logo.png" alt="NixOS Logo" width="200"/>
</div>

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

---


