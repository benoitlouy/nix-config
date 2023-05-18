self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "1.6.1";

    src = self.fetchurl {
      url = "https://github.com/ciderapp/Cider/releases/download/v${version}/Cider-${version}.AppImage";
      hash = "sha256-ZQAteYZdL2Z0KP2KH3e0VPA019kYMwTd2ls5rxavPsU=";
    };

    extraInstallCommands =
      let contents = self.appimageTools.extract { inherit pname version src; };
      in
      ''
        mv $out/bin/${pname}-${version} $out/bin/${pname}

        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';

    meta = with self.lib; {
      description = "A new look into listening and enjoying Apple Music in style and performance.";
      homepage = "https://github.com/ciderapp/Cider";
      license = licenses.agpl3;
      maintainers = [ maintainers.cigrainger ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
