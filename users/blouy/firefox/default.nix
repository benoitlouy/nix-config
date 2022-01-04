{ pkgs, config, ... }:

let
  firefox = pkgs.callPackage ./firefox-mac.nix { };
in
{

  programs.firefox = {
    enable = true;
    package = firefox;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      onepassword-password-manager
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
        default = {
          isDefault = true;
          settings = {
            "signon.rememberSignons" = false;
          };
        };
      };

  };
}
