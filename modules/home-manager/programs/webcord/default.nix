{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.webcord
    # pkgs.gtkcord4
    pkgs.legcord
    pkgs.element-desktop
    pkgs.vesktop
  ];
}
