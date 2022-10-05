let
  overlays = [
    (import ./firefox.nix)
    (import ./packr.nix)
    (import ./chatty.nix)
    (import ./yabai.nix)
    (import ./tree-sitter-smithy.nix)
    (import ./devx.nix)
    (import ./git.nix)
  ];
  composeOverlays = overlays: self: super:
    super.lib.foldl' (super.lib.flip super.lib.extends) (super.lib.const super) overlays self;
in
  self: super: composeOverlays overlays self super
