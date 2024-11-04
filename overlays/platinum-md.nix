self: super:

{
  platinum-md = self.appimageTools.wrapType2 rec {
    pname = "platinum-md";
    version = "0.7.0";

    src = self.fetchurl {
      url = "https://github.com/gavinbenda/platinum-md/releases/download/v${version}-alpha/platinum-md-${version}.AppImage";
      hash = "sha256-8nikRHzpGtHx+KexEtat/dFb+KHgAefZXVipfLjqfKY=";
    };

    extraInstallCommands =
      let contents = self.appimageTools.extract { inherit pname version src; };
      in
      ''
        echo ${contents}
        mkdir -p $out/share/applications
        install -m 444 ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
  };
}
