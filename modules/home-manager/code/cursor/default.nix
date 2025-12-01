{ pkgs, ... }:
{
  home.packages = [
    pkgs.code-cursor
    pkgs.cursor-cli
  ];
}
