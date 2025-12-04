{
  description = "NixOS system flake with Hyprland";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
   
    zed.url = "github:zed-industries/zed";

    # Secure Boot with Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, hyprland, lanzaboote, zed, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    # Expose Zed as a package in your flake
    packages.${system}.zed-latest = zed.packages.${system}.default;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        # Hardware and base configuration
        ./configuration.nix
        ./hardware-configuration.nix
        
        # Lanzaboote module for Secure Boot
        lanzaboote.nixosModules.lanzaboote

        # Small inline module to install Zed system-wide
        ({ config, pkgs, ... }: {
          environment.systemPackages = [
            self.packages.${system}.zed-latest
          ];
        })
      ];
    };
  };
}

