{ config, pkgs, ... }:
{
  home.packages = [ pkgs.webcord pkgs.gtkcord4 pkgs.armcord pkgs.element-desktop pkgs.vesktop ];
}
