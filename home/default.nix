{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    inherit (nixpkgsConfig) config overlays;
  };
in
{
  blouy =
    let
      user = {
        username = "blouy";
        email = "benoit.louy@fastmail.com";
        sshkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgJGjz/y+YG4ZIZiblYyFxqFKKvRgN0ByggtMUaXBiT";
        sign-with-ssh = true;
        use-one-password = false;
      };
      host = {
        isWork = false;
      };
    in
      inputs.home-manager.lib.homeManagerConfiguration rec {
        inherit pkgs;
        modules = pkgs.lib.attrValues homeManagerModules ++ [
          ../modules/config/keymap.nix
          {
            home.stateVersion = "22.11";
            home.username = user.username;
            home.homeDirectory = "/home/blouy";
          }
          ((import ../users/blouy) user host)
          {
            targets.genericLinux = {
              enable = true;
            };
          }
          ../modules/ssh-agent
        ];
     };
}
