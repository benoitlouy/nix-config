{ config, pkgs, ... }:
{
  home.packages = [ pkgs.cliphist pkgs.wl-clipboard ];
}
