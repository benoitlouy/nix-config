{ config, pkgs, ... }:

{
  options = {
    term-font-size = pkgs.lib.mkOption {
      default = 12;
      type = pkgs.lib.types.int;
    };
  };
}
