{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Nix Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    auto-optimise-store = true;
  };

  # Grabage Collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network & Time
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Display Manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # User
  users.users.giyu = {
    isNormalUser = true;
    description = "Rohit";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.zsh;
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };
  programs.starship.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    # Core
    git vim neovim wget curl tree htop btop fastfetch tmux unzip zip
    
    # Dev Tools
    gcc nodejs_22 python3 python3Packages.pip direnv nix-direnv bun rustup go
    
    # Terminals & File Managers
    kitty ghostty kdePackages.dolphin 

    # Editors
    vscode code-cursor
    
    # Apps
    google-chrome brave vesktop spotify obsidian vlc libreoffice fractal
    
    # Hyprland
    waybar dunst rofi hyprpaper hyprlock hypridle hyprpicker
    grim slurp swappy wl-clipboard cliphist
    networkmanagerapplet pavucontrol brightnessctl playerctl polkit_gnome
    
    # Theming
    papirus-icon-theme catppuccin-gtk catppuccin-cursors.mochaPink nwg-look
    
    # Dev LSP/Formatters
    prettierd eslint_d stylua black nixfmt-rfc-style
    lua-language-server pyright nodePackages.typescript-language-server nodePackages.bash-language-server
    
    # CLI Tools
    fzf bat fd ripgrep eza
    
    # Docker
    docker docker-compose
    
    # Utilities
    pciutils usbutils gnome-keyring libsecret
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    font-awesome
    material-design-icons
    jetbrains-mono
    fira-code
  ];

  

  # Services
  services = {
    openssh.enable = true;
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  security.polkit.enable = true;
  
  # Polkit Agent
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

  # Docker
  virtualisation.docker.enable = true;

  # Power Management
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

  # Environment Variables
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
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.portal.xdgOpenUsePortal = true;

  system.stateVersion = "25.05";
}
