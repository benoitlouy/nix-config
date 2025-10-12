{ config, pkgs, ... }:

{
  xdg.configFile = {
    "swaync/style.css".source = ./rose-pine/style.css;
    "swaync/config.json".source = ./rose-pine/config.json;
  };
}
