self: super:

{
  yabai = super.stdenv.mkDerivation rec {
    pname = "yabai";
    version = "5.0.2";

    src = super.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-wL6N2+mfFISrOFn4zaCQI+oH6ixwUMRKRi1dAOigBro=";
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
