{ config, pkgs, ... }:
{
  programs.streamlink = {
    enable = false;
    settings = {
      player = "${pkgs.mpv}/bin/mpv";
      # twitch-low-latency = null;
    };
  };
}
