{ config, pkgs, ... }:
{
  home.packages = [ pkgs.cinnamon.nemo ];
}
