{ config, pkgs, ... }:
{
  services.geoclue2 = {
    enable = true;
  };
}
