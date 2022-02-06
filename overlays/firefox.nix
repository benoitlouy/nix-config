self: super:

{
  firefox-bin = super.stdenv.mkDerivation rec {
      pname = "Firefox";
      version = "95.0.2";

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
        sha256 = "1msm2abdlc3kfplbvhz0grbisg6zjqpkgjqcyy2fgsm86zbyf3q4";
      };

      meta = with super.lib; {
        description = "The Firefox web browser";
        homepage = "https://www.mozilla.org/en-GB/firefox";
        platforms = platforms.darwin;
      };
    };
}
