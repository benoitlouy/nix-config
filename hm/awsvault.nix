{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.awsvault;
in
{
  options.programs.awsvault = {
    enable = mkEnableOption "aws-vault - store and access AWS credentials in dev environments";

    backend = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "keychain";
      description = ''
        Secret backend to use [keychain pass file]
      '';
    };

    prompt = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "terminal";
      description = ''
        Prompt driver to use [kdialog osascript pass terminal ykman zenity]
      '';
    };

    passCmd = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "${pkgs.pass}/bin/pass";
      description = ''
        Name of the pass executable
      '';
    };

    passPrefix = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "";
      description = ''
        Prefix to prepend to the item path stored in pass
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.aws-vault
    ];

    home.sessionVariables = mapAttrs (n: v: toString v)
      (filterAttrs (n: v: v != [ ] && v != null) {
        AWS_VAULT_PROMPT = cfg.prompt;
        AWS_VAULT_BACKEND = cfg.backend;
        AWS_VAULT_PASS_CMD = cfg.passCmd;
        AWS_VAULT_PASS_PREFIX = cfg.passPrefix;
      });

  };
}
