self: super:

{
  chatty-twitch = super.stdenv.mkDerivation rec {
    pname = "chatty";
    version = "0.24.1";

    src = super.fetchzip {
      url = "https://github.com/chatty/chatty/releases/download/v${version}/Chatty_${version}.zip";
      hash = "sha256-uce8nIjvAQ7IJbTLMrs8MD5z7xdtX2lPL41CRnNeLpE=";
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

      ${self.jdk}/bin/jpackage --name Chatty \
        --input . \
        --main-jar Chatty.jar \
        --app-version 1.0.0 \
        --icon chatty.icns \
        --jlink-options --bind-services
    '';

    installPhase = ''
      mkdir -p "$out/Applications"
      find . -type f
      ${self.undmg}/bin/undmg Chatty-1.0.0.dmg
      cp -r Chatty.app "$out/Applications/Chatty.app"
    '';

  };
}
