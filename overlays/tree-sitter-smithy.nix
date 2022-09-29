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

}
