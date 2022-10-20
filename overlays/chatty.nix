self: super:

{
  chatty-twitch = super.stdenv.mkDerivation rec {
    pname = "chatty";
    version = "0.21";

    src = super.fetchzip {
      url = "https://github.com/chatty/chatty/releases/download/v${version}/Chatty_${version}.zip";
      hash = "sha256-kt2NPtGpUQ42301YYbu7OzDs1KuyoPEemimu2Di9+TA=";
      stripRoot = false;
    };

    icon = super.fetchurl {
      url = "https://github.com/chatty/chatty.github.io/raw/master/img/app_main_32.png";
      hash = "sha256-HR7Y9gUTdrNi+tP8CGzPU4pC+Sz5sidVC0mq3E334wc=";
    };

    buildPhase = ''
      mkdir -p chatty.iconset
      cp $icon chatty.iconset/icon_32x32.png
      /usr/bin/iconutil --convert icns chatty.iconset

      ${self.jdk8}/bin/java -jar ${self.packr-jar}/lib/packr-all.jar \
       --platform mac \
       --jdk ${self.jdk8} \
       --useZgcIfSupportedOs \
       --executable Chatty \
       --classpath Chatty.jar \
       --mainclass chatty.Chatty \
       --vmargs Xmx1G \
       --output Chatty.app \
       --icon chatty.icns
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Chatty.app "$out/Applications/Chatty.app"
    '';

  };
}
