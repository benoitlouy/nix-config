self: super:

let
  plugin = {
    nvim-heirline = super.vimUtils.buildVimPluginFrom2Nix {
      name = "nvim-heirline";
      src = super.fetchFromGitHub {
        owner = "rebelot";
        repo = "heirline.nvim";
        rev = "f46554a0a4ea096867deb6ef8877cccbf5b7261b";
        hash = "sha256-uWtOfGlnqhcTq2x/ti1Wpymi7HSkrsiWZ77YGmuk6Gw=";
      };
    };
  };
in
{
  vimPlugins = super.vimPlugins // plugin;
}
