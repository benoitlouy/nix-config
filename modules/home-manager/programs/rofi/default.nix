{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  xdg.configFile = {
    "rofi/launcher.sh".text = import ./launcher.nix { inherit pkgs; };
  };
}
