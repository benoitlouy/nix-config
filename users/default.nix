{ inputs, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs-unstable.lib) attrValues;

  homeManagerStateVersion = "22.11";

  homeManagerCommonConfig = { user, host, ... }: {
    imports = attrValues homeManagerModules ++ [
      inputs.hyprland.homeManagerModules.default
      ((import ../users/${user.username}) user host)
      ../users/common.nix
      { home.stateVersion = homeManagerStateVersion; }
    ];
  };
  mkUser = args @ { user, host, ... }: {
    users.users.${user.username} = {
      home = "/home/${user.username}";
    };
    home-manager.users.${user.username} = homeManagerCommonConfig args;
  };

  blouy = mkUser {
    user = {
      username = "blouy";
      email = "benoit.louy@fastmail.com";
    };
    host = {
      isWork = false;
    };
  };


in
{
  inherit blouy;
}
