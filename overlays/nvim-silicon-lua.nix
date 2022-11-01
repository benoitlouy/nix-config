self: super:

let
  plugin = {
    silicon-lua = super.vimUtils.buildVimPluginFrom2Nix {
      name = "silicon.lua";
      src = super.fetchFromGitHub {
        owner = "narutoxy";
        repo = "silicon.lua";
        rev = "b17444e25f395fd7c7c712b46aa7977cc8433c84";
        hash = "sha256-nFcCeXWHO6+YXfuUUXuxgjBHyYaPO0myj0fkeqyxPFA=";
      };
    };
  };
in {
  vimPlugins = super.vimPlugins // plugin;
}
