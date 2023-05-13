let
  overlays = [
    #(import ./firefox.nix)
    #(import ./packr.nix)
    #(import ./chatty.nix)
    #(import ./yabai.nix)
    # (import ./tree-sitter-smithy.nix)
    (import ./devx.nix)
    # (import ./git.nix)
    (import ./vpn.nix)
    (import ./bamc.nix)
    # (import ./nvim-smart-splits.nix)
    (import ./smithy-language-server.nix)
    (import ./nvim-silicon-lua.nix)
    (import ./giter8.nix)
    (import ./rofi-launcher.nix)
    (import ./xdph-launcher.nix)
    (import ./waybar.nix)
    (import ./swaylock-launcher.nix)
  ];
  composeOverlays = overlays: self: super:
    super.lib.foldl' (super.lib.flip super.lib.extends) (super.lib.const super) overlays self;
in
  self: super: composeOverlays overlays self super
