let
  overlays = [
    # (import ./wxpython.nix)
    #(import ./firefox.nix)
    (import ./packr.nix)
    (import ./chatty.nix)
    # (import ./yabai.nix)
    (import ./devx.nix)
    (import ./vpn.nix)
    (import ./bamc.nix)
    (import ./smithy-language-server.nix)
    (import ./nvim-silicon-lua.nix)
    (import ./giter8.nix)
    (import ./rofi-launcher.nix)
    (import ./xdph-launcher.nix)
    # (import ./cider.nix)
    (import ./rofi-1pass)
    # (import ./signal-desktop.nix)
    (import ./syncthing-gtk.nix)
    (import ./power-desktop-items.nix)
    # (import ./metals.nix)
    (import ./smithytranslate.nix)
    (import ./diagnosticls-configs-nvim.nix)
    (import ./grimblast.nix)
    (import ./ansel.nix)
    (import ./battery-notify)
    (import ./electronwmd.nix)
    (import ./platinum-md.nix)
    (import ./nightfox-gtk-theme.nix)
    (import ./material-symbols.nix)
    (import ./lualine-nvim.nix)
    (import ./easytag)
  ];
  composeOverlays = overlays: self: super:
    super.lib.foldl' (super.lib.flip super.lib.extends) (super.lib.const super) overlays self;
in
  self: super: composeOverlays overlays self super
