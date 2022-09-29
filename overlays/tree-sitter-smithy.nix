self: super:

{
  tree-sitter-grammars.tree-sitter-smithy = super.tree-sitter-grammars.tree-sitter-smithy.overrideAttrs (
    old: rec {
      version = "581f16381a0ca7b95f460874159958170d25ad54";

      src = self.fetchFromGitHub {
        owner = "benoitlouy";
        repo = "tree-sitter-smithy";
        rev = "smithy2";
        hash = "sha256-QON4Jp5LuPc9xYoTosrc/ggQB19afwtjDEvsfbwiiZ4=";
      };
    }
  );

  # tree-sitter-grammars.tree-sitter-smithy = super.stdenv.mkDerivation rec {
  #   pname = "tree-sitter-smithy";
  #   version = "581f16381a0ca7b95f460874159958170d25ad54";

  #   src = self.fetchzip {
  #     url = "https://github.com/benoitlouy/tree-sitter-smithy/archive/${version}.tar.gz";
  #     hash = "sha256-QON4Jp5LuPc9xYoTosrc/ggQB19afwtjDEvsfbwiiZ4=";
  #   };

  #   buildInputs = [ super.tree-sitter ];

  #   dontUnpack = true;
  #   dontConfigure = true;

  #   CFLAGS = [ "-I${src}/src" "-O2" ];
  #   CXXFLAGS = [ "-I${src}/src" "-O2" ];

  #   # When both scanner.{c,cc} exist, we should not link both since they may be the same but in
  #   # different languages. Just randomly prefer C++ if that happens.
  #   buildPhase = ''
  #     runHook preBuild
  #     if [[ -e "$src/src/scanner.cc" ]]; then
  #       $CXX -c "$src/src/scanner.cc" -o scanner.o $CXXFLAGS
  #     elif [[ -e "$src/src/scanner.c" ]]; then
  #       $CC -c "$src/src/scanner.c" -o scanner.o $CFLAGS
  #     fi
  #     $CC -c "$src/src/parser.c" -o parser.o $CFLAGS
  #     $CXX -shared -o parser *.o
  #     runHook postBuild
  #   '';

  #   installPhase = ''
  #     runHook preInstall
  #     mkdir $out
  #     mv parser $out/
  #     runHook postInstall
  #   '';

  #   # Strip failed on darwin: strip: error: symbols referenced by indirect symbol table entries that can't be stripped
  #   fixupPhase = super.lib.optionalString super.stdenv.isLinux ''
  #     runHook preFixup
  #     $STRIP $out/parser
  #     runHook postFixup
  #   '';
  # };
}
