self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.1.1";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/905459703092490340/1132270268950253711/Cider-2.1.1.AppImage";
      hash = "sha256-29gQ+DOaTB+CoN9Sx56Z9MBZo6VzeQgKa1xYpAfic8s=";
      # url = "https://cdn.discordapp.com/attachments/905459703092490340/1113901383712788510/Cider-2-2.0.3.AppImage";
      # hash = "sha256-UACBamAjrEbRsMezlP9FIL3X6eie307ESo+ZU5xeUlg=";
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
