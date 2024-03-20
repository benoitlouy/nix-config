self: super:

{
  yabai = super.stdenv.mkDerivation rec {
    pname = "yabai";
    version = "6.0.15";

    src = super.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-L82N0IaC2OAZVhmu9NALencK78FeCZI2cWJyNkGH2vQ=";
    };

    nativeBuildInputs = [
      super.installShellFiles
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r ./bin $out
      installManPage ./doc/yabai.1
      runHook postInstall
    '';

  };
}
