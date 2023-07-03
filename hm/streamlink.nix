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

  config =
    let
      dst = if pkgs.stdenv.isDarwin then "Library/Application Support/streamlink/config" else ".config/streamlink/config";
    in
    mkIf cfg.enable {
      home.packages = [ cfg.package ];
      home.file.${dst}.text = cfg.config;
    };
}
