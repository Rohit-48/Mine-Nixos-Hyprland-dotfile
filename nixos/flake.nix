{
  description = "NixOS system flake with Hyprland and Secure Boot";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    
    # Secure Boot with Lanzaboote (using latest commit instead of v0.4.1)
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, hyprland, lanzaboote, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Hardware and base configuration
        ./configuration.nix
        ./hardware-configuration.nix
        
        # Lanzaboote module for Secure Boot
        lanzaboote.nixosModules.lanzaboote
      ];
    };
  };
}
