{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.cinnamon.nemo-with-extensions
    pkgs.cinnamon.nemo-fileroller
    pkgs.cinnamon.nemo-python
    pkgs.gvfs # support for remote server connections
  ];
}
