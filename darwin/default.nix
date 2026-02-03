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
      inputs.zen-browser.homeModules.beta
      ../modules/keymap/colemakdh.nix
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/zen
      ../modules/home-manager/code/cursor
    ];
  };

  blouy = users.blouy {
    extraModules = [
      inputs.zen-browser.homeModules.beta
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/zen
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
      ../modules/keymap.nix
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
      ../modules/keymap.nix
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
      ../modules/darwin/services/primaryUser/blouy.nix
    ] ++ home-manager ++ [ blouy ];
  };

  Work = darwinSystem rec {
    system = "aarch64-darwin";
    modules = [
      # inputs.lix-module.nixosModules.default
      common
      ./common.nix
      ../modules/darwin/system/stateVersion/4.nix
      ../modules/keymap.nix
      ../modules/keymap/colemakdh.nix
      ../modules/darwin/services/yabai
      ../modules/darwin/services/skhd
      ../modules/darwin/services/primaryUser
    ] ++ home-manager ++ [ benoitlouy ];
  };
}
