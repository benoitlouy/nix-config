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

    spacebar.url = "github:cmacrae/spacebar/v1.3.0";
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
          self.overlay
          spacebar.overlay
        ];
      };

      homeManagerStateVersion = "22.05";

      homeManagerCommonConfig = { user, ... }: {
        imports = attrValues self.homeManagerModules ++ [
          ((import ./users/${user.username}) user)
          ./users
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };

      nixDarwinCommonModules = args @ { user, ... }: [
        home-manager.darwinModules.home-manager
        rec {
          nixpkgs = nixpkgsConfig;
          users.users.${user.username}.home = "/Users/${user.username}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user.username} = homeManagerCommonConfig args;
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
        streamlink = (import ./hm/streamlink.nix);
      };

      darwinConfigurations = {

        M = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./bootstrap.nix
          ] ++ nixDarwinCommonModules {
            user = {
              username = "blouy";
              email = "benoit.louy@fastmail.com";
            };
          };
        };

        Work = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./bootstrap.nix
          ] ++ nixDarwinCommonModules {
            user = {
              username = "blouy";
              email = "benoit.louy@disneystreaming.com";
            };
          };
        };
      };

    };
}
