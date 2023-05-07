self: super:

let
  sha = "3cf516293d8b08f6714d02deca526d3f583bd2a0";

  version = "8.9";

  platform = super.stdenv.targetPlatform;
  arch = "amd64";
  os =
    if platform.isMacOS then "darwin"
    else abort "unsupported platform";

  vendor = builtins.fetchurl {
    url =
      "https://artifactory.us-east-1.bamgrid.net/artifactory/ced-go/${os}_${arch}/bamc_vendor_${version}.tgz";
    sha256 = "1z4zmfq65mm9xn1bfirsnmcq96whp7vh78pxp0i7r3blxlqsg1iq";
  };

in
{
  bamc = super.stdenv.mkDerivation {
    name = "bamc-${version}";
    buildInputs = [ self.gnutar self.go self.git ];

    src = builtins.fetchGit {
      url = "git@github.bamtech.co:ced-go/bamc.git";
      rev = "3cf516293d8b08f6714d02deca526d3f583bd2a0";
    };

    GOFLAGS = "-mod=vendor";

    buildPhase = ''
        mkdir $TMPDIR/sources
        cp -R --no-preserve=mode,ownership * $TMPDIR/sources
        cd $TMPDIR
        tar xzf ${vendor}
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH="$TMPDIR/go"
        cd $TMPDIR/sources
        go build -o bamc \
        -ldflags "${
      builtins.concatStringsSep " " [
        "-X 'golang.global.bamgrid.net/ced-go/bamc/cmd.version=${version}'"
        "-X 'golang.global.bamgrid.net/ced-go/bamc/cmd.gitHash=${sha}'"
      ]
      }"
        cd $TMPDIR'';

    installPhase = ''
      mkdir -p $out/bin
      cp $TMPDIR/sources/bamc $out/bin'';
  };
}
