{ config, pkgs, ... }:
{
  home.packages = [ pkgs.anyrun ];

  xdg.configFile."anyrun/config.ron".source = ./config.ron;
  xdg.configFile."anyrun/style.css".source = ./style.css;
}
