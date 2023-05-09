{ inputs, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs-unstable.lib) attrValues;

  homeManagerStateVersion = "22.11";

  homeManagerCommonConfig = { user, host, extraModules, ... }: {
    imports = attrValues homeManagerModules ++ [
      inputs.hyprland.homeManagerModules.default
      ((import ../users/${user.username}) user host)
      ../users/common.nix
      { home.stateVersion = homeManagerStateVersion; }
    ] ++ extraModules;
  };
  mkUser = args @ { user, host, extraModules, ... }: {
    users.users.${user.username} = {
      home = "/home/${user.username}";
    };
    home-manager.users.${user.username} = homeManagerCommonConfig args;
  };

  blouy = { extraModules }: mkUser {
    inherit extraModules;
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
