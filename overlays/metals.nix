self: super:

{
  metals = super.stdenv.mkDerivation
    rec {
      pname = "metals";
      version = "1.0.0";

      deps = super.stdenv.mkDerivation {
        name = "${pname}-deps-${version}";
        buildCommand = ''
          export COURSIER_CACHE=$(pwd)
          ${self.coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
            -r bintray:scalacenter/releases \
            -r sonatype:snapshots > deps
          mkdir -p $out/share/java
          cp $(< deps) $out/share/java/
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-futBxdMEJN0UdDvlk5FLUUmcG7r7P7D81IhbC2oYn5s=";
      };

      nativeBuildInputs = [ self.makeWrapper self.setJavaClassPath ];
      buildInputs = [ deps ];

      dontUnpack = true;

      extraJavaOpts = "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m";

      installPhase = ''
        mkdir -p $out/bin

        makeWrapper ${self.jre}/bin/java $out/bin/metals \
          --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"
      '';

      meta = with super.lib; {
        homepage = "https://scalameta.org/metals/";
        license = licenses.asl20;
        description = "Work-in-progress language server for Scala";
        maintainers = with maintainers; [ fabianhjr tomahna ];
      };
    };
}
