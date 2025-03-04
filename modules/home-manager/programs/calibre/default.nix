{ pkgs, ... }:

{
  home.packages = [
    pkgs.calibre
    pkgs.kcc
    # pkgs.wineWowPackages.stable
    # pkgs.wineWowPackages.waylandFull
    # pkgs.wine64
    # pkgs.winetricks
  ];
}
