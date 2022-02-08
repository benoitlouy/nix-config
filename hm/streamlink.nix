{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.streamlink;
in
{
  options.programs.streamlink = {
    enable = mkEnableOption "streamlink";

    package = mkOption {
      type = types.package;
      default = pkgs.streamlink;
      defaultText = "pkgs.streamlink";
      description = "The streamlink package to use";
    };

    config = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.file."Library/Application Support/streamlink/config".text = cfg.config;
  };
}
