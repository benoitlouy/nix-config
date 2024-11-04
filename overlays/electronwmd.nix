self: super:

{
  electronwmd = self.appimageTools.wrapType2 rec {
    pname = "electronwmd";
    version = "0.5.0-1.5.0";

    src = self.fetchurl {
      url = "https://github.com/asivery/ElectronWMD/releases/download/v${version}/electronwmd-${version}-linux_x86_64.AppImage";
      hash = "sha256-NTrQv7Xseg7dOJEYFdIAYcb9mdt6vsBLK3APQV0L4KI=";
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
