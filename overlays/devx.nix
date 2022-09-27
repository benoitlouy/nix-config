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
    version = "2.24.1";

    src = super.fetchurl {
      url = "https://artifactory.us-east-1.bamgrid.net/artifactory/devp-generic/devx-cli/binaries/devx-cli-${os}${arch}/devx-cli-${os}${arch}-${version}.bin";
      hash = "sha256-Z3RXcux9RQk3XoJeOigBfWLlT6u7u5xvGTDsFdV9R9o=";
    };

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/devx
    '';

  };
}
