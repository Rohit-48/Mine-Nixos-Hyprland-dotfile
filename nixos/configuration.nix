# /etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  ########################################
  # Boot & Kernel
  ########################################
  boot.kernelPackages = pkgs.linuxPackages_6_6;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  ########################################
  # Network & Locale
  ########################################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Kolkata";
  
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };
  };

  ########################################
  # Display (Hyprland Only - No KDE)
  ########################################
  
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display Manager - SDDM configured for Hyprland

services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
  
  # settings goes INSIDE the sddm block, and it's a set (use = not ;)
  settings = {
    General = {
      Numlock = "on";
    };
  };
};

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ########################################
  # Sound & Bluetooth
  ########################################
  # Disable PulseAudio (using PipeWire instead)
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ########################################
  # Users
  ########################################
  users.users.giyu = {
    isNormalUser = true;
    description = "Rohit";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;

  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    histSize = 1000;

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
  };

  ########################################
  # System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    # Core tools
    git
    vim
    neovim
    wget
    tree
    htop
    btop
    fastfetch
    tmux

    # Development
    gcc
    nodejs_22
    python3
    direnv
    nix-direnv
    bun
    rustup
    go
    
    # Terminals & Editors
    kitty
    ghostty
    nitch
    code-cursor
    zed-editor
    vscode
    spotify
    notion-app 

    # Browsers & Communication
    google-chrome
    discord
    
    # Clipboard (Essential for Hyprland)
    wl-clipboard
    cliphist
    
    # Hyprland essentials
    waybar
    dunst
    rofi
    hyprpaper
    hyprlock
    hypridle
    hyprpicker
    grim
    slurp
    swappy
    networkmanagerapplet
    pavucontrol
    brightnessctl
    playerctl
    polkit_gnome
    swayidle

    # Catppuccin theme (recommended - matches your setup)
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "JetBrains Mono";
      fontSize = "12";
      background = "/home/giyu/Pictures/minewallpapers/starbase4.jpeg";
      loginBackground = true;
      })
    
    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin

    # Theming & Icons
    papirus-icon-theme
    catppuccin-gtk
    catppuccin-cursors.mochaPink
    nwg-look
    starship
    
    # Formatters / Linters
    prettierd
    eslint_d
    stylua
    black
    
    # Language servers
    lua-language-server
    pyright
    typescript
    bash-language-server
    dockerfile-language-server
    yaml-language-server
    marksman

    # Telescope / fzf support
    fzf
    bat
    fd
    ripgrep

    # Docker
    docker
    docker-compose
    
    # Media
    vlc
    obsidian
    libreoffice
    
    # System Information
    pciutils
    gnome-keyring
    libsecret
  ];

  ########################################
  # Fonts
  ########################################
  fonts.packages = with pkgs; [
    # Nerd Fonts - New individual package syntax
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
    
    # Regular fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    
    # Icon fonts
    font-awesome
    material-design-icons

    corefonts  # <— this one includes Courier New, Arial, Times New Roman, etc.
          jetbrains-mono
  ];

  ########################################
  # Docker
  ########################################
  virtualisation.docker.enable = true;

  ########################################
  # Flatpak
  ########################################
  services.flatpak.enable = true;

  ########################################
  # Graphics (Intel integrated)
  ########################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ########################################
  # Power Management
  ########################################
  services.power-profiles-daemon.enable = false;
  
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  ########################################
  # Services
  ########################################
  services.openssh.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  # Polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  # XDG Portals - Simplified configuration
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk 
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  programs.dconf.enable = true;
  
  # Enable XDG autostart
  xdg.autostart.enable = true;

  # Thunar integration
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  ########################################
  # Environment Variables (Wayland)
  ########################################
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_SIZE = "24";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  ########################################
  # System State Version
  ########################################
  system.stateVersion = "25.05";
}
