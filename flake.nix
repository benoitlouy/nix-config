{
  description = "blouy darwin system";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nur.url = "github:nix-community/NUR";

    launchd_shim = {
      url = "github:benpye/launchd_shim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, nur, ... } @ inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues;

      nixpkgsConfig = with inputs; rec {
        config = {
          allowUnfree = true;
        };
        overlays = [
          nur.overlay
          launchd_shim.overlay
          self.overlay
        ];
      };

      homeManagerStateVersion = "22.05";

      homeManagerCommonConfig = { user, ... }: {
        imports = attrValues self.homeManagerModules ++ [
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

      overlay = import ./overlays;

      homeManagerModules = {
        awscli = (import ./hm/awscli.nix);
      };

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
