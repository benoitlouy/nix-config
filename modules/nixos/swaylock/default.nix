{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.swaylock-effects
    pkgs.swaylock-launcher
  ];

  security.pam.services.swaylock = { };
}
