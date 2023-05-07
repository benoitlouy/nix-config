self: super:

{
  packr-jar = super.stdenv.mkDerivation rec {
    pname = "packr";
    version = "4.0.0";

    src = super.fetchurl {
      url = "https://github.com/libgdx/packr/releases/download/${version}/packr-all-${version}.jar";
      hash = "sha256-4gR/WwmL1coFFQpTDzraOn8HvYRr5zC5I3gYC909i+I=";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/lib
      cp $src $out/lib/packr-all.jar
    '';
  };
}
