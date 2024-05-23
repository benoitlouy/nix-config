self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.4.0";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/1212935842897731604/1224462799162441902/Cider-2.4.0.AppImage?ex=662eb858&is=662d66d8&hm=945d427c93f322e0c1a8f26a30128befbee570d60b1a64397fbcdee6401e8896&";
      hash = "sha256-V8vO+6vKB80q1GV4ng5HY2SvnC4Ob1yK1Gf0NZJ79nw=";
      # url = "https://cdn.discordapp.com/attachments/1092593196862808084/1218155763672023070/Cider-2.3.2.AppImage?ex=6606a2f6&is=65f42df6&hm=7c76ae19c960c784607508018652c464ff97ed662cc0e27d205aa34b1ca09cb7&";
      # hash = "sha256-8xhAfHer5vKqhnCZnYlOVDsTD3I7pnO9cIHVxyogFA4=";
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
