{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.unstable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "@admin"
      ];
    };
  };

  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      if [[ -d "/Applications/Nix Apps" ]]; then
        rm -rf "/Applications/Nix Apps"
      fi

      mkdir -p "/Applications/Nix Apps"

      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        echo "copying $app"
        cp -rL "$src" "/Applications/Nix Apps"
      done
    ''
  );

  system.stateVersion = 4;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;


}
