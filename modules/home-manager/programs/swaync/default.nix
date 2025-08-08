{ config, pkgs, ... }:
let
  swaync-config = pkgs.replaceVars ./config.json {
    configSchema = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
  };
in
{
  xdg.configFile = {
    "swaync/style.css".source = ./rose-pine/style.css;
    "swaync/config.json".source = ./rose-pine/config.json;
  };
}
