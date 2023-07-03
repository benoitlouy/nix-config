{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openvpn
    networkmanager-openvpn
    gnome.networkmanager-openvpn
  ];
}
