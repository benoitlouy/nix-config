{ config, pkgs, ... }:
{
  home.packages = [ pkgs.webcord pkgs.gtkcord4 pkgs.armcord ];
}
