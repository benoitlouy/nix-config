self: super:

{
  smithy-language-server = super.stdenv.mkDerivation rec {
    pname = "smithy-language-server";
    version = "0.7.0";

    deps = super.stdenv.mkDerivation {
      name = "${pname}-deps-${version}";
      buildCommand = ''
        ${super.coursier}/bin/cs fetch \
          -J-Duser.home=$TMPDIR \
          --cache $(pwd) \
          software.amazon.smithy:${pname}:${version} > $TMPDIR/deps
        mkdir -p $out/share/java
        cp -r $(< $TMPDIR/deps) $out/share/java/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-9ToElrSkWXNL1EQlCsnb00jhsGeWAgalUDOUzjoFHZ4=";
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
