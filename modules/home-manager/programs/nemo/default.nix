{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.cinnamon.nemo-with-extensions
    pkgs.cinnamon.nemo-fileroller
  ];
}
