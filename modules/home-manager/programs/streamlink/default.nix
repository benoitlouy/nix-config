{ config, pkgs, ... }:
{
  programs.streamlink = {
    enable = true;
    config = ''
      player=mpv
      twitch-low-latency
    '';
  };
}
