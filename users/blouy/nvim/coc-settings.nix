{
  "coc" = {
    "preferences" = {
      formatOnSaveFiletypes = [ "scala" ];
    };
  };
  "metals" = {
    "statusBarEnabled" = true;
  };
  "languageserver" = {
    "dhall" = {
      "command" = "dhall-lsp-server";
      "filetypes" = [ "dhall" ];
    };

    "elm" = {
      "command" = "elm-language-server";
      "filetypes" = [ "elm" ];
      "rootPatterns" = [ "elm.json" ];
    };

    "haskell" = {
      "command" = "haskell-language-server-wrapper";
      "args" = [ "--lsp" ];
      "rootPatterns" = [
        "stack.yaml"
        "hie.yaml"
        ".hie-bios"
        "BUILD.bazel"
        ".cabal"
        "cabal.project"
        "package.yaml"
      ];
      "filetypes" = [ "hs" "lhs" "haskell" ];
    };

    "nix" = {
      "command" = "rnix-lsp";
      "filetypes" = [ "nix" ];
    };
  };

  "yank.highlight.duration" = 700;
}
