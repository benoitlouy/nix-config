self: super:

{
  smithy-language-server = super.stdenv.mkDerivation rec {
    pname = "smithy-language-server";
    version = "0.0.19";
    src = ./.;

    builldInputs = [
      super.coursier
    ];

    buildPhase = ''
      mkdir $TMPDIR/cs_cache
      mkdir $TMPDIR/home
      ${super.coursier}/bin/cs bootstrap -J-Duser.home=$TMPDIR/home --cache $TMPDIR/cs_cache --standalone com.disneystreaming.smithy:${pname}:${version} -o ${pname}
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ${pname} $out/bin
    '';
  };
}
