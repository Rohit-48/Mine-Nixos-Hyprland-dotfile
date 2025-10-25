# /etc/nixos/configuration.nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ########################################
  # Nix Configuration
  ########################################
  nixpkgs.config.allowUnfree = true;
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    
    # Hyprland Cachix - IMPORTANT: Add this BEFORE using Hyprland flake
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    
    # Optimization
    auto-optimise-store = true;
  };
  
  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ########################################
  # Boot & Kernel
  ########################################
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
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
  # Hyprland Configuration
  ########################################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Use Hyprland from flake
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Sync portal package
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  ########################################
  # Display Manager
  ########################################
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };

  ########################################
  # XDG Portals
  ########################################
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = [ "hyprland" "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };

  ########################################
  # Sound (PipeWire)
  ########################################
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ########################################
  # Bluetooth
  ########################################
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  ########################################
  # Graphics
  ########################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

  ########################################
  # Shell Configuration
  ########################################
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  
  programs.starship.enable = true;

  ########################################
  # System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    # Essential tools
    git
    vim
    neovim
    wget
    curl
    tree
    htop
    btop
    fastfetch
    neofetch
    tmux
    unzip
    zip
    
    # Development
    gcc
    nodejs_22
    python3
    python3Packages.pip
    direnv
    nix-direnv
    bun
    rustup
    go
    
    # Terminals
    kitty
    ghostty
    
    # Editors & IDEs
    zed-editor
    vscode
    
    # Apps
    google-chrome
    discord
    spotify
    obsidian
    
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
    wl-clipboard
    cliphist
    networkmanagerapplet
    pavucontrol
    brightnessctl
    playerctl
    polkit_gnome
    
    # File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.tumbler  # Thumbnail support
    
    # Theming
    papirus-icon-theme
    catppuccin-gtk
    catppuccin-cursors.mochaPink
    nwg-look
    
    # Development tools
    prettierd
    eslint_d
    stylua
    black
    nixfmt-rfc-style
    
    # LSP
    lua-language-server
    pyright
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    
    # CLI tools
    fzf
    bat
    fd
    ripgrep
    eza
    
    # Docker
    docker
    docker-compose
    
    # Media
    vlc
    libreoffice
    
    # System utilities
    pciutils
    usbutils
    gnome-keyring
    libsecret
  ];

  ########################################
  # Fonts
  ########################################
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
    
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    
    font-awesome
    material-design-icons
    
    jetbrains-mono
    fira-code
  ];

  ########################################
  # Programs
  ########################################
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  
  programs.dconf.enable = true;

  ########################################
  # Services
  ########################################
  services.openssh.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  
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

  ########################################
  # Docker
  ########################################
  virtualisation.docker.enable = true;

  ########################################
  # Power Management (Laptop)
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
  # Environment Variables
  ########################################
  environment.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    
    # Hyprland
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_SIZE = "24";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    
    # Editor
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  ########################################
  # Flatpak (Optional)
  ########################################
  services.flatpak.enable = true;
  xdg.portal.xdgOpenUsePortal = true;

  ########################################
  # System State Version
  ########################################
  system.stateVersion = "25.05";
}
