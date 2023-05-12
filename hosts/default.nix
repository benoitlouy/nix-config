{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs-unstable.lib) nixosSystem attrValues;

  common = {
    nixpkgs = nixpkgsConfig;
  };

  home-manager = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];

  users = import ../users { inherit inputs homeManagerModules; };

  blouy = users.blouy {
    extraModules = [
      inputs.hyprland.homeManagerModules.default
      ../modules/home-manager/programs/hyprland
      ../modules/home-manager/programs/mako
      ../modules/home-manager/programs/waybar
      ../modules/home-manager/programs/rofi
      ../modules/home-manager/programs/streamlink
    ];
  };

in
{
  L = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit inputs system; };
    modules = [
      ./L/configuration.nix
      common
      ../modules/nixos/hyprland
      ../modules/nixos/fonts.nix
      ../modules/nixos/light.nix
    ] ++ home-manager ++ [ blouy ];
  };
}
