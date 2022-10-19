self: super:

{
  smithy-language-server = super.stdenv.mkDerivation rec {
    pname = "smithy-language-server";
    version = "0.0.19";

    deps = super.stdenv.mkDerivation {
      name = "${pname}-deps-${version}";
      buildCommand = ''
        ${super.coursier}/bin/cs fetch \
          --cache $(pwd) \
          com.disneystreaming.smithy:${pname}:${version} > $TMPDIR/deps
        mkdir -p $out/share/java
        cp -r $(< $TMPDIR/deps) $out/share/java/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-X8U8VfOi2dpJAGtQzL/Fgfr+8mpCi6Oqvjk8VCsjTTE=";
    };

    nativeBuildInputs = [ super.makeWrapper super.setJavaClassPath ];
    buildInputs = [ deps ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${super.jre}/bin/java $out/bin/${pname} \
        --add-flags "-cp $CLASSPATH software.amazon.smithy.lsp.Main"
    '';
  };
}
