{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.swaynotificationcenter
  ];
}
