self: super:

{
  yabai = super.stdenv.mkDerivation rec {
    pname = "yabai";
    version = "7.1.14";

    src = super.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      hash = "sha256-cDONHrNPBTzEkVqxN1cHDqVumfyfcHrTYGZxn4s/mEA=";
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
