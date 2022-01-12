{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.finto;

  configFile = mkIf (cfg.config != {} || cfg.extraConfig != "")
    "${pkgs.writeScript "fintorc" (
      (if (cfg.config != {})
       then "${toYabaiConfig cfg.config}"
       else "")
      + optionalString (cfg.extraConfig != "") ("\n" + cfg.extraConfig + "\n"))}";
in
{
  options = with types; {
    services.finto.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable finto.";
    };

    services.finto.package = mkOption {
      type = path;
      description = "The finto package to use.";
    };

    # services.finto.config
  };

  config = (mkIf (cfg.enable)) {
    environment.systemPackages = [ cfg.package ];

    # launchd.user.agents.finto = {
    #   serviceConfig.ProgramArguments = [ "${cfg.package}/bin/finto" ]
    #     ++ optionals (cfg.config != { } || cfg.extraConfig != "") [ "-c" configFile ];

    #   serviceConfig.KeepAlive = true;
    #   serviceConfig.RunAtLoad = true;
    #   serviceConfig.EnvironmentVariables = {
    #     PATH = "${cfg.package}/bin:${config.environment.systemPath}";
    #   };
    # };
  };
}
