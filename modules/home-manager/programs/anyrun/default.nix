{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.anyrun
    pkgs.power-desktop-items
    pkgs.gtk4
  ];

  xdg.configFile."anyrun/config.ron".source = ./config.ron;
  xdg.configFile."anyrun/style.css".source = ./style.css;
}
