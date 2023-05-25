{ config, pkgs, ... }:
{
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    # defaultSymlinkPath = "/run/user/${toString user.uid}/secrets";
    # defaultSecretsMountPoint = "/run/user/${toString user.uid}/secrets.d";
    # secrets.blouy_secret = { };
  };
}
