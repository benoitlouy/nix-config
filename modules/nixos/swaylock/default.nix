{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.swaylock-launcher
  ];

  security.pam.services.swaylock = { };
  #   text = ''
  #     auth include login
  #   '';
  # };
}
