self: super:

{
  yabai = super.stdenv.mkDerivation rec {
    pname = "yabai";
    version = "5.0.1";

    src = super.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-iCx/e3IwJ6YzgEy7wGkNQU/d7gaZd4b/RLwRvRpwVwQ=";
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
