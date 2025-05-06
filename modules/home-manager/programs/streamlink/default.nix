{ config, pkgs, ... }:
{
  programs.streamlink = {
    enable = true;
    settings = {
      player = "${pkgs.mpv}/bin/mpv";
      twitch-low-latency = "";
    };
  };
}
