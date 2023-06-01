{ config, pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
