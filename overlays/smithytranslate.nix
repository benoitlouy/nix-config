self: super:

{
  smithytranslate = super.stdenv.mkDerivation rec {
    pname = "smithytranslate";
    version = "0.3.11";

    deps = super.stdenv.mkDerivation {
      name = "${pname}-deps-${version}";
      buildCommand = ''
        export COURSIER_CACHE=$(pwd)
        ${self.coursier}/bin/cs fetch com.disneystreaming.smithy:smithytranslate-cli_2.13:${version} > deps
        mkdir -p $out/share/java
        cp $(< deps) $out/share/java/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      # outputHash = "sha256-C5qRIb6Q9QVggnoclJN+7w9fORDV/rus9cv3F/VaYU8=";
    };

    nativeBuildInputs = [ self.makeWrapper self.setJavaClassPath ];
    buildInputs = [ deps ];

    dontUnpack = true;

    extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

    installPhase = ''
      mkdir -p $out/bin

      makeWrapper ${self.jre}/bin/java $out/bin/smithytranslate \
        --add-flags "${extraJavaOpts} -cp $CLASSPATH smithytranslate.cli.Main"
    '';
  };
}
