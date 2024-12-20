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
    version = "3.9.9";

    src = super.fetchurl {
      url = "https://artifactory.us-east-1.bamgrid.net/artifactory/devp-generic/devx-cli/binaries/devx-cli-${os}${arch}/devx-cli-${os}${arch}-${version}.bin";
      hash = "sha256-VUosxKCJbC7s/85539DX9pBf4sSoD0MR9isuTEh71GA=";
    };

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/devx
      chmod +x $out/bin/devx
    '';

  };
}
