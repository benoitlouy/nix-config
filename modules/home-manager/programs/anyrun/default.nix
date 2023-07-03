{ config, pkgs, ... }:
let
  anyrun-cliphist-launcher = pkgs.writeShellScriptBin "anyrun-cliphist-launcher" ''
    ${pkgs.anyrun}/bin/anyrun -o ${pkgs.anyrun-cliphist}/lib/libanyrun_cliphist.so
  '';

  anyrun-op-launcher = pkgs.writeShellScriptBin "anyrun-op-launcher" ''
    ${pkgs.anyrun}/bin/anyrun -o ${pkgs.anyrun-op}/lib/libanyrun_op.so
  '';
in
{
  home.packages = [
    pkgs.anyrun
    pkgs.power-desktop-items
    anyrun-cliphist-launcher
    anyrun-op-launcher
  ];

  xdg.configFile."anyrun/config.ron".source = ./config.ron;
  xdg.configFile."anyrun/style.css".source = ./style.css;
  xdg.configFile."anyrun/cliphist.ron".text = ''
    Config(
        max_entries: 10,
        cliphist_path: "${pkgs.cliphist}/bin/cliphist",
    )
  '';
  xdg.configFile."anyrun/op.ron".text = ''
    Config(
        max_entries: 10,
        op_path: "/run/wrappers/bin/op",
    )
  '';
}
