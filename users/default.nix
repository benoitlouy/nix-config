{ inputs, homeManagerModules, ... }:


let
  inherit (inputs.nixpkgs.lib) attrValues;

  homeManagerStateVersion = "22.11";

  homeManagerCommonConfig = { user, host, extraModules, ... }: {
    imports = attrValues homeManagerModules ++ [
      ((import ./${user.username}) user host)
      ./common.nix
      { home.stateVersion = homeManagerStateVersion; }
    ] ++ extraModules;
  };


  mkUser = args @ { user, host, extraModules, ... }: { pkgs, ... }:
    let
      homeBase = if pkgs.stdenv.isDarwin then "/Users" else "/home";
    in
    {
      users.users.${user.username} = {
        home = "${homeBase}/${user.username}";
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

  "benoit.louy" = { extraModules }: mkUser {
    inherit extraModules;
    user = {
      username = "benoit.louy";
      email = "benoit.louy@disneystreaming.com";
    };
    host = {
      isWork = true;
    };
  };


in
{
  inherit blouy;
  inherit "benoit.louy";
}
