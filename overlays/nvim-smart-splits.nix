self: super:

let
  plugin = {
    smart-splits = super.vimUtils.buildVimPlugin rec {
      name = "smart-splits";
      version = "981f9666db6ce1471b27ee16031e8386cb4650bc";
      src = super.fetchFromGitHub {
        owner = "mrjones2014";
        repo = "smart-splits.nvim";
        rev = version;
        hash = "sha256-skWxB6EnulqmxHhgcm6FSwCtstbrw8P05KMR0aLF59w=";
      };
    };
  };
in
{
  vimPlugins = super.vimPlugins // plugin;
}
