self: super:

{
  firefox-bin = super.stdenv.mkDerivation rec {
      pname = "Firefox";
      version = "105.0";

      buildInputs = [ super.pkgs.undmg ];
      sourceRoot = ".";
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir -p "$out/Applications"
        cp -r Firefox.app "$out/Applications/Firefox.app"
      '';

      src = super.fetchurl {
        name = "Firefox-${version}.dmg";
        url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
        hash = "sha256-jkjv0S9bFpAtOGulSkUG0SirlbQn71uXmsRsvbcT5Ys=";
      };

      meta = with super.lib; {
        description = "The Firefox web browser";
        homepage = "https://www.mozilla.org/en-GB/firefox";
        platforms = platforms.darwin;
      };
    };
}
