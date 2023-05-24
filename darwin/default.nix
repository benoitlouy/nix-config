{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  inherit (inputs.darwin.lib) darwinSystem;

  common = {
    nixpkgs = nixpkgsConfig;
  };

  home-manager = [
    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
    }
  ];

  users = import ../users { inherit inputs homeManagerModules; };

  benoitlouy = users."benoit.louy" {
    extraModules = [
      ../modules/home-manager/programs/streamlink
    ];
  };

  blouy = users.blouy {
    extraModules = [
      ../modules/home-manager/programs/streamlink
    ];
  };
in
{
  M = darwinSystem rec {
    system = "x86_64-linux";
    modules = [
      common
      ./common.nix
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
    ] ++ home-manager ++ [ blouy ];
  };

  Work = darwinSystem rec {
    system = "aarch64-darwin";
    modules = [
      common
      ./common.nix
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
    ] ++ home-manager ++ [ benoitlouy ];
  };
}
