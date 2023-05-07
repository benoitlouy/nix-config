self: super:

{
  vpn = super.stdenv.mkDerivation rec {
    pname = "vpn";
    version = "1.0.0";

    src = ../scripts/vpn;

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/vpn
    '';
  };
}
