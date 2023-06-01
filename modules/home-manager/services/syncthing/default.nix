{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.syncthing-gtk
  ];

  services.syncthing = {
    enable = true;
    tray = {
      enable = false;
    };
  };
}
