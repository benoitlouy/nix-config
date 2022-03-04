self: super:

{
  chatty-twitch = super.stdenv.mkDerivation rec {
    pname = "chatty";
    version = "0.17";

    src = super.fetchzip {
      url = "https://github.com/chatty/chatty/releases/download/v${version}/Chatty_${version}.zip";
      hash = "sha256-NQng57BGU7gEY93hkCNqtMj0hvjcyQkyrOwGBD3tcmE=";
      stripRoot = false;
    };

    buildInputs = [
      self.adoptopenjdk-hotspot-bin-8
      self.packr-jar
    ];

    buildPhase = ''
      ${self.adoptopenjdk-hotspot-bin-8}/bin/java -jar ${self.packr-jar}/lib/packr-all.jar \
       --platform mac \
       --jdk ${self.adoptopenjdk-hotspot-bin-8} \
       --useZgcIfSupportedOs \
       --executable Chatty \
       --classpath Chatty.jar \
       --mainclass chatty.Chatty \
       --vmargs Xmx1G \
       --output Chatty.app
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Chatty.app "$out/Applications/Chatty.app"
    '';

  };
}
