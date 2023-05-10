{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
    };
    settings = [
      {
        position = "top";
        layer = "top";
        modules-center = [
          "clock"
        ];
      }
    ];
  };
}
