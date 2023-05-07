self: super:

{
  git = super.git.overrideAttrs (
    old: rec {
      version = "2.38.0";
      src = self.fetchurl {
        url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
        hash = "sha256-kj6t4msYFN540GvajgqfXai3xLMEs/kFD/tGTwMQMgo=";
      };
    }
  );
}
