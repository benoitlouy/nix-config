self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.4.0";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/1092593196862808084/1237243259802222592/Cider-2.4.0.AppImage?ex=6650b0d4&is=664f5f54&hm=2c4bc3cdba31c6d7ef1addb1a29f383754e53d60d618ae39326fb8c333decc38&";
      hash = "sha256-PSOJYaxEGahqX/7XIKkAiObqHwuAu6YI7CF/qc9DOZU=";
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
