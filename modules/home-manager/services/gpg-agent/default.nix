{ config, pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
}
