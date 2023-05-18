{ config, pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
  };
}
