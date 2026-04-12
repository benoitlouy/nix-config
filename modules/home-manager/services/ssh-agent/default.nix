{ config, pkgs, ... }:
{
  services.ssh-agent = {
    enable = true;
  };

  home.sessionVariables.SSH_AUTH_SOCK = pkgs.lib.mkIf config.services.ssh-agent.enable "$XDG_RUNTIME_DIR/ssh-agent";
}
