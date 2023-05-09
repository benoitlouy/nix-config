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
      ../modules/programs/mako
      ../modules/programs/waybar
      ../modules/programs/rofi
      ../modules/programs/streamlink
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
      ./L/home.nix
    ] ++ home-manager ++ [ blouy ];
  };
}
