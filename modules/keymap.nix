{config, pkgs, ...}:

{
  options = {
    keymap = pkgs.lib.mkOption {
      default = "qwerty";
      type = with pkgs.lib.types; enum ["qwerty" "colemak-dh"];
    };
  };
}
