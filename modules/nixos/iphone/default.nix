{ config, pkgs, ... }:
{
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

  # for wireguard
  networking.firewall.checkReversePath = "loose";
}
