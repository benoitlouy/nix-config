self: super:

{
  coc-metals = super.vimPlugins.coc-metals.overrideAttrs (
    old: rec {
      version = "1.0.12-blouy";
      src = builtins.fetchurl {
        url = "https://registry.npmjs.org/coc-metals/-/coc-metals-1.0.12.tgz";
        sha256 = "1bhwlb46djf81d4h2cbbm7i0brcfhidg5zc71xslwb5qh2wsjb4z";
      };
    }
  );
}
