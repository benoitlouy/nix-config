self: super:

{
  giter8 = super.stdenv.mkDerivation rec {
    pname = "giter8";
    version = "0.16.1";

    deps = super.stdenv.mkDerivation {
      name = "${pname}-deps-${version}";
      buildCommand = ''
        ${super.coursier}/bin/cs fetch \
          -J-Duser.home=$TMPDIR \
          --cache $(pwd) \
          org.foundweekends.giter8::${pname}:${version} > $TMPDIR/deps
        mkdir -p $out/share/java
        cp -r $(< $TMPDIR/deps) $out/share/java/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-iLUYOboV5GFkmDcsz2dyFS1krXM9cPlSMZmiM0d3mHM=";
    };

    nativeBuildInputs = [ super.makeWrapper super.setJavaClassPath ];
    buildInputs = [ deps ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${super.jre}/bin/java $out/bin/g8 \
        --add-flags "-cp $CLASSPATH giter8.Giter8"
    '';
  };
}
