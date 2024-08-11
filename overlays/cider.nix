self: super:

{
  cider = self.appimageTools.wrapType2 rec {
    pname = "cider";
    version = "2.4.0";

    src = self.fetchurl {
      url = "https://cdn.discordapp.com/attachments/1212935842897731604/1257953778871697480/Cider-2.5.0.AppImage?ex=6686f100&is=66859f80&hm=32a36e9252d9f57e2e5c62fb87393ce020d45d4d375de6c3b3cf11ff7c4dab82&";
      hash = "sha256-93VEVvLv0WtmfnpgD/t01rPw4hyQFAViyl6XwFd0kTo=";
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
