{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.swayidle-launcher
    pkgs.swayidle
  ];
}
