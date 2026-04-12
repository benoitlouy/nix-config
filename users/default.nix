{ inputs, homeManagerModules, ... }:


let
  inherit (inputs.nixpkgs.lib) attrValues;

  homeManagerStateVersion = "22.11";

  homeManagerCommonConfig = { user, host, extraModules, ... }: {
    imports = attrValues homeManagerModules ++ [
      ../modules/config
      ((import ./${user.username}) user host)
      ./common.nix
      { home.stateVersion = homeManagerStateVersion; }
      inputs.nix-index-database.homeModules.nix-index
      { programs.nix-index-database.comma.enable = true; }
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
      sshkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgJGjz/y+YG4ZIZiblYyFxqFKKvRgN0ByggtMUaXBiT";
      sign-with-ssh = true;
      use-one-password = true;
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
      sshkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFrkvFPq7VndyfmKbc5lV/4i5rgLf2JeZA299oK6q7bK";
      sign-with-ssh = false;
      use-one-password = true;
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
