{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.grimblast
    pkgs.grimblast-desktop-items
  ];
}
