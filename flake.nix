{
  description = "flake configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdph = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, darwin, hyprland, xdph, anyrun, sops-nix, ... } @ inputs:
    let
      inherit (nixpkgs.lib) attrValues;

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./overlays)
          anyrun.overlay
        ];
      };
    in
    rec {
      nixosConfigurations = import ./hosts { inherit inputs nixpkgsConfig homeManagerModules; };

      darwinConfigurations = import ./darwin { inherit inputs nixpkgsConfig homeManagerModules; };

      homeManagerModules = {
        awscli = (import ./hm/awscli.nix);
        streamlink = (import ./hm/streamlink.nix);
      };
    };
}
