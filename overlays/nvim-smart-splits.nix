self: super:

let
  plugin = {
    smart-splits = super.vimUtils.buildVimPluginFrom2Nix {
      name = "smart-splits";
      src = super.fetchFromGitHub {
        owner = "mrjones2014";
        repo = "smart-splits.nvim";
        rev = "981f9666db6ce1471b27ee16031e8386cb4650bc";
        hash = "sha256-skWxB6EnulqmxHhgcm6FSwCtstbrw8P05KMR0aLF59w=";
      };
    };
  };
in
{
  vimPlugins = super.vimPlugins // plugin;
}
