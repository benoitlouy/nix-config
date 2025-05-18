self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.0.3";

    src = ./cider-v2.0.3-linux-x64.AppImage;

    extraInstallCommands =
      let contents = self.appimageTools.extract { inherit pname version src; };
      in
      ''
        cat ${contents}/Cider.desktop
        install -m 444 -D ${contents}/Cider.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/Cider.desktop \
          --replace 'Exec=Cider %U' 'Exec=cider'
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
