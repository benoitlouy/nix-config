{
  description = "blouy darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      nix.package = pkgs.nixFlakes;
    };
  in
  {
    darwinConfigurations."M" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ configuration darwin.darwinModules.simple ];
    };

    darwinPakages = self.darwinConfigurations."M".pkgs;
  };
}
