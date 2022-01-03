{ pkgs, config, ... }:

let
  firefox = pkgs.callPackage ./firefox-mac.nix { };
  # nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };

  # nur-no-pkgs = import nur {
  #   nurpkgs = pkgs;
  # };
in
{

  programs.firefox = {
    enable = true;
    package = firefox;
    # extensions = with nur.repos.rycee.firefox-addons; [
    #   ublock-origin
    #   # vimium
    # ];
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
        default = {
          isDefault = true;
          settings = {
            "signon.rememberSignons" = false;
          };
        };
      };

  };
}
