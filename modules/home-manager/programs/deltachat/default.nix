{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.deltachat-desktop
  ];
}
