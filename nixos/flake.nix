{
  description = "NixOS system flake (no Home Manager) — Hyprland only";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";


    # Hyprland window manager
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # Ensure hyprland uses the same nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  
  outputs = { self, nixpkgs, hyprland, ... }:
    let
      system = "x86_64-linux";
      hostname = "nixos";
    in {
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };
    };
}
