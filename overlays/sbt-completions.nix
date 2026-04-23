prev: final:
{
  sbt-completions = final.stdenv.mkDerivation rec {
    pname = "sbt-completions";
    version = "1.12.9";

    src = final.fetchzip {
      url = "https://github.com/sbt/sbt/archive/refs/tags/v${version}.tar.gz";
      hash = "sha256-PgC5HYAhUnNpkHqmfDAIg2Mtbcz3oJPlWqFsUUhyREY=";
    };

    nativeBuildInputs = [ final.installShellFiles ];

    postInstall = ''
      installShellCompletion --cmd sbtn \
        --zsh <(cat ${src}/client/completions/_sbtn) \
        --bash <(cat ${src}/client/completions/sbtn.bash)
        #mkdir -p $out/share/zsh/site-functions
        #cp ${src}/client/completions/_sbtn $out/share/zsh/site-functions/_sbtn
      '';
  };

}
