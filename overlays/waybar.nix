self: super:

{
  waybar = super.waybar.overrideAttrs (
    old: {
      mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
    }
  );
}
