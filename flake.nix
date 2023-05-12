{
  description = "flake configuration";

  inputs = {
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixos-hardware, home-manager, hyprland, xdph, ... } @ inputs:
    let
      inherit (nixpkgs-unstable.lib) attrValues;

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./overlays)
        ];
      };
    in
    rec {
      nixosConfigurations = import ./hosts { inherit inputs nixpkgsConfig homeManagerModules; };

      homeManagerModules = {
        awscli = (import ./hm/awscli.nix);
        streamlink = (import ./hm/streamlink.nix);
      };
    };
}
