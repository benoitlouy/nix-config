let
  overlays = [
    (import ./firefox.nix)
    (import ./finto.nix)
    (import ./coc-metals.nix)
  ];
  composeOverlays = overlays: self: super:
    super.lib.foldl' (super.lib.flip super.lib.extends) (super.lib.const super) overlays self;
in
  self: super: composeOverlays overlays self super
