{ config, pkgs, ... }:
{
  home.packages = [ pkgs.cider pkgs.vlc ];
}
