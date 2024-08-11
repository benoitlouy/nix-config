{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.nemo-with-extensions
    pkgs.nemo-fileroller
    pkgs.nemo-python
    pkgs.gvfs # support for remote server connections
  ];
}
