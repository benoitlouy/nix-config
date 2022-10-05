self: super:

let
  platform = super.stdenv.targetPlatform;
  arch = if platform.isAarch64 then "-arm64" else "";
  os = if platform.isMacOS then "macos"
       else if platform.isLinux then "linux"
       else if platform.isWindows then "windows"
       else abort "unsupported platform";
in
{
  devx = super.stdenv.mkDerivation rec {
    pname = "devx";
    version = "2.24.2";

    src = super.fetchurl {
      url = "https://artifactory.us-east-1.bamgrid.net/artifactory/devp-generic/devx-cli/binaries/devx-cli-${os}${arch}/devx-cli-${os}${arch}-${version}.bin";
      hash = "sha256-jXc/Lmsp2yu3LUvvlHkJlvWDdZyxbcu12/FKjvZlOLg=";
    };

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/devx
    '';

  };
}
