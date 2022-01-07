{ lib, ... }:

let
  overlays = [
    (import ./firefox)
  ];
  composeOverlays = overlays: self: super:
    lib.foldl' (lib.flip lib.extends) (lib.const super) overlays self;
in {
  overlay = self: super: composeOverlays overlays self super;
}
