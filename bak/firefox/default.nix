{ pkgs, config, ... }:

let
  firefox = pkgs.callPackage ./firefox-mac.nix { };
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in
{

  programs.firefox = {
    enable = true;
    package = firefox;
    extensions = with nur.repos.rycee.firefox-addons; [
      ublock-origin
      vimium
    ];
    profiles =
      let defaultSettings = {
        "app.update.auto" = false;
        "browser.startup.homepage" = "about:blank";
        # *snip* no need to splurge all my settings, you get the idea...
        # "identity.fxaccounts.account.device.name" = config.networking.hostName;
        "signon.rememberSignons" = false;
      };
      in
      {
        home = {
          id = 0;
          settings = {
            "signon.rememberSignons" = false;
          };
        };
      };

    };
  }
