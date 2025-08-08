{ config, pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
