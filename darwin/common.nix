{ config, pkgs, ... }:
{
  nix = {
    # package = pkgs.nixVersions.git;
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

      IFS='
      '
      # shellcheck disable=SC2044
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        echo "copying $app"
        cp -rL "$src" "/Applications/Nix Apps"
      done
    ''
  );

  # system.stateVersion = 4;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };
  };

  programs.zsh.enable = true;

  # see https://github.com/nix-community/home-manager/issues/1341#issuecomment-3256894180
  # copy home manager installed apps to /Applications
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      {

        targets.darwin.linkApps.enable = false;
      }
    )
  ];
  system.build.applications = pkgs.lib.mkForce (
    pkgs.buildEnv {
      name = "system-applications";
      pathsToLink = ["/Applications"];
      paths =
        config.environment.systemPackages
        ++ (pkgs.lib.concatMap (x: x.home.packages) (pkgs.lib.attrsets.attrValues config.home-manager.users));
    }
  );

}
