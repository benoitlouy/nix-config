{ inputs, nixpkgsConfig, users, ... }:

let
  inherit (inputs.nixpkgs-unstable.lib) nixosSystem;

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
in
{
  L = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit inputs system; };
    modules = [
      ./L/configuration.nix
      common
    ] ++ home-manager ++ [ users.blouy ];
  };
}
