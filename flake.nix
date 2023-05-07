{
  description = "flake configuration";

  inputs = {
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-unstable, nixos-hardware, home-manager, ... } @ inputs:
    let
      inherit (nixpkgs-unstable.lib) attrValues;

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./overlays)
        ];
      };

      homeManagerStateVersion = "22.11";

      homeManagerCommonConfig = { user, host, ... }: {
        imports = attrValues self.homeManagerModules ++ [
          ((import ./users/${user.username}) user host)
          ./users
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };
      mkUser = args @ { user, host, ... }: {
        users.users.${user.username}.home = "/home/${user.username}";
        home-manager.users.${user.username} = homeManagerCommonConfig args;
      };

      blouy = { system, ... }: mkUser {
        user = {
          username = "blouy";
          email = "benoit.louy@fastmail.com";
        };
        host = {
          inherit system;
          isWork = false;
        };
      };
    in
    {
      nixosConfigurations = {
        L = nixpkgs-unstable.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-z13
            home-manager.nixosModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            # (blouy system)
            (blouy { inherit system; })
          ];
        };
      };

      homeManagerModules = {
        awscli = (import ./hm/awscli.nix);
        streamlink = (import ./hm/streamlink.nix);
      };
    };
}
