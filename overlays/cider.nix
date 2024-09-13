self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.4.0";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/1092593196862808084/1274060002990100632/Cider-1.0.0.AppImage?ex=66cc1517&is=66cac397&hm=1775c4068b330ed8dcb4757450c692b6ea4fd56ac4915819a60381c758af92b4&";
      hash = "sha256-rTSFaZK5incYxqUHlkdSMmCK4kK3N72qRZUSpDK3rqg=";
    };

    extraInstallCommands =
      let contents = self.appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';

    meta = with self.lib; {
      description = "A new look into listening and enjoying Apple Music in style and performance.";
      homepage = "https://github.com/ciderapp/Cider";
      license = licenses.gpl3;
      maintainers = [ maintainers.cigrainger ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
