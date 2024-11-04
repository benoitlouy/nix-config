self: super:

{
  atracdenc = super.stdenv.mkDerivation rec {
    pname = "atracdenc";
    version = "0.1.1";

    src = self.fetchFromGitHub {
      owner = "dcherednik";
      repo = "atracdenc";
      rev = "${version}";
      hash = "sha256-h2sjzWXLO45W0+SvLu2ljforipNPLKu2Gp0E1mgMIIg=";
    };

    nativeBuildInputs = [ self.cmake ];

    buildInputs = [ self.libsndfile ];

    env.CXXFLAGS = toString [ "-include cstdint" ];

  };
}
