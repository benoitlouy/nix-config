{ pkgs, ... }:
{
  home.packages = [
    pkgs.kdenlive
    pkgs.noson
    pkgs.soco-cli
    pkgs.electronwmd
    pkgs.qpwgraph
    pkgs.qjackctl
    pkgs.helvum
    pkgs.audacity
    pkgs.ardour
    pkgs.streamrip
    pkgs.strawberry
    pkgs.easyeffects
    pkgs.ffmpeg
    pkgs.platinum-md
  ];
}
