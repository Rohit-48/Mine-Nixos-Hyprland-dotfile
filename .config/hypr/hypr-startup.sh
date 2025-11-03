#!/usr/bin/env bash
# ~/.config/hypr/hypr-startup.sh
# Complete autostart script for Hyprland on NixOS

# Wait for Hyprland to fully initialize
sleep 1

# Import environment for systemd services
systemctl --user import-environment PATH WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Kill any existing instances to avoid duplicates
pkill waybar
pkill dunst
pkill nm-applet
pkill polkit-gnome

# Start wallpaper daemon
if command -v hyprpaper &>/dev/null; then
  pkill hyprpaper
  hyprpaper &
elif command -v swww &>/dev/null; then
  pkill swww-daemon
  swww-daemon &
  sleep 1
  swww img ~/Pictures/Wallpaper-Bank/wallpapers/Dynamic-Wallpapers/Light/Village-Light.png --transition-type wipe --transition-duration 2
fi

# Start status bar
waybar &

# Start notification daemon
dunst &

# Wait for system tray to be ready
sleep 2

# Start network manager applet
nm-applet --indicator &

# Start Bluetooth manager (if you use it)
blueman-applet &

# Start clipboard manager
if command -v cliphist &>/dev/null; then
  wl-paste --type text --watch cliphist store &
  wl-paste --type image --watch cliphist store &
fi

# Start polkit authentication agent
if [ -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
else
  POLKIT=$(find /nix/store -name "*polkit-gnome*" -type d | head -n 1)
  "$POLKIT/libexec/polkit-gnome-authentication-agent-1" &
fi

# Start portal services
systemctl --user restart xdg-desktop-portal.service &
systemctl --user restart xdg-desktop-portal-hyprland.service &

# Set cursor theme (if you use custom cursor)
# hyprctl setcursor Catppuccin-Mocha-Pink-Cursors 24

echo "✓ Hyprland autostart complete!"
