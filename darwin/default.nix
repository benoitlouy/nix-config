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
      home-manager.extraSpecialArgs =  {
        inherit inputs;
      };
    }
  ];

  users = import ../users { inherit inputs homeManagerModules; };

  benoitlouy = users."benoit.louy" {
    extraModules = [
      inputs.zen-browser.homeModules.beta
      ../config/Work
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/zen
      ../modules/home-manager/code/cursor
      ../modules/home-manager/code/amazonq
      ../modules/home-manager/programs/ghostty
    ];
  };

  blouy = users.blouy {
    extraModules = [
      inputs.zen-browser.homeModules.beta
      ../config/A
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/zen
      ../modules/home-manager/programs/ghostty
    ];
  };
in
{
  M = darwinSystem rec {
    system = "x86_64-linux";
    modules = [
      common
      ./common.nix
      ../modules/darwin/system/stateVersion/4.nix
      ../modules/config
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
    ] ++ home-manager ++ [ blouy ];
  };

  A = darwinSystem rec {
    system = "aarch64-darwin";
    modules = [
      common
      ./common.nix
      ../modules/darwin/system/stateVersion/6.nix
      ../modules/config
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
      ../modules/darwin/services/primaryUser/blouy.nix
      ../config/A
    ] ++ home-manager ++ [ blouy ];
  };

  Work = darwinSystem rec {
    system = "aarch64-darwin";
    modules = [
      # inputs.lix-module.nixosModules.default
      common
      ./common.nix
      ../modules/darwin/system/stateVersion/4.nix
      ../modules/config
      ../config/Work
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
      ../modules/darwin/services/primaryUser
      ../config/Work
    ] ++ home-manager ++ [ benoitlouy ];
  };
}
