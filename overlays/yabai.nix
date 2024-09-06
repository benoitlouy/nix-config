self: super:

{
  yabai = super.stdenv.mkDerivation rec {
    pname = "yabai";
    version = "7.1.2";

    src = super.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-4ZJs7Xpou0Ek0CCCjbK47Nu/XPpuTpBDU8GJz5AsaUg=";
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
