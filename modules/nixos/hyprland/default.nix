{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  # environment.systemPackages = [
  #   pkgs.xdg-desktop-portal-gtk
  # ];

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };
}
