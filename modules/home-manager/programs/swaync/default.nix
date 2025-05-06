{ config, pkgs, ... }:
let
  swaync-config = pkgs.replaceVars ./config.json {
    configSchema = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
  };
in
{
  xdg.configFile = {
    "swaync/style.css".source = ./mocha.css;
    "swaync/config.json".source = swaync-config;
  };
}
