{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.avizo
  ];
}
