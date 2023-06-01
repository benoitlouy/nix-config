self: super:

{
  cider2 = self.appimageTools.wrapType2 rec {
    pname = "cider2";
    version = "2.0.3";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/905459703092490340/1111706552571789432/Cider-2-2.0.3.AppImage";
      hash = "sha256-ke5d3iL51wEtP3pxmDJlq8UA3/ir224FRYm+eHdczxs=";
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
