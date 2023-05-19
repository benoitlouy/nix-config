{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem attrValues;

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
      ../modules/home-manager/programs/swaync
      ../modules/home-manager/programs/mako
      ../modules/home-manager/programs/waybar
      ../modules/home-manager/programs/rofi
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/cider
      ../modules/home-manager/programs/webcord
      ../modules/home-manager/programs/nemo
      ../modules/home-manager/programs/cliphist
      ../modules/home-manager/programs/audio
      ../modules/home-manager/services/gpg-agent
      ../modules/home-manager/programs/swww
      ../modules/home-manager/programs/anyrun
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
      ../modules/nixos/swaylock
      ../modules/nixos/swayidle
      ../modules/nixos/fonts.nix
      ../modules/nixos/light.nix
      ../modules/nixos/polkit
      ../modules/nixos/avizo
      ../modules/nixos/swaync
    ] ++ home-manager ++ [ blouy ];
  };
}
