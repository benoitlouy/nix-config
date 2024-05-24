self: super:

{
  ansel = self.appimageTools.wrapType2 rec {
    pname = "ansel";
    version = "55d8a7a";

    src = self.fetchurl {
      url = "https://github.com/aurelienpierreeng/ansel/releases/download/v0.0.0/Ansel-${version}-x86_64.AppImage";
      hash = "sha256-DaIeanGA6YgNFChkGhJ79phkcasHt6Wm+9+gK4wA3mM=";
    };

    extraPkgs = pkgs: with pkgs; [
      libthai
      isocodes
    ];

    extraInstallCommands =
      let contents = self.appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${contents}/photos.ansel.app.desktop -t $out/share/applications
        # substituteInPlace $out/share/applications/photos.ansel.app.desktop \
        #   --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
  };
}
