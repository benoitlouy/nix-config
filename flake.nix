{
  description = "flake configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    anyrun = {
      url = "github:benoitlouy/anyrun/add-overlays";
      # url = "github:anyrun-org/anyrun";
      # url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-cliphist = {
      url = "github:benoitlouy/anyrun-cliphist/update-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-op = {
      url = "github:benoitlouy/anyrun-op/update-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-hyprland-window-switcher = {
      url = "github:benoitlouy/anyrun-hyprland-window-switcher/update-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      inherit (nixpkgs.lib) attrValues;

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./overlays)
          inputs.anyrun.overlays.default
          inputs.hypr-contrib.overlays.default
          inputs.anyrun-cliphist.overlays.default
          inputs.anyrun-op.overlays.default
          inputs.anyrun-hyprland-window-switcher.overlays.default
        ];
      };
    in
    rec {
      nixosConfigurations = import ./hosts { inherit inputs nixpkgsConfig homeManagerModules; };

      darwinConfigurations = import ./darwin { inherit inputs nixpkgsConfig homeManagerModules; };

      homeManagerModules = {
        awsvault = (import ./hm/awsvault.nix);
        streamlink = (import ./hm/streamlink.nix);
      };
    };
}
