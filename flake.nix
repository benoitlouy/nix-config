{
  description = "blouy darwin system";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, ... } @ inputs:
    let
      inherit (darwin.lib) darwinSystem;

      nixpkgsConfig = with inputs; rec {
        config = {
          allowUnfree = true;
        };
        overlays = [ nur.overlay ];
      };

      homeManagerStateVersion = "22.05";

      homeManagerCommonConfig = { user, ... }: {
        imports = [
          ./users/${user}
          ./users
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };

      nixDarwinCommonModules = args @ { user, ... }: [
        home-manager.darwinModules.home-manager
        rec {
          nixpkgs = nixpkgsConfig;
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig args;
        }
      ];

      configuration = { pkgs, ... }: {
        nix.package = pkgs.nixFlakes;
      };
    in
    rec {
      darwinConfigurations = {

        M = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./bootstrap.nix
          ] ++ nixDarwinCommonModules {
            user = "blouy";
          };
        };

        Work = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./bootstrap.nix
          ] ++ nixDarwinCommonModules {
            user = "blouy";
          };
        };
      };

    };
}
