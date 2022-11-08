self: super:

let
  plugin = {
    silicon-lua = super.vimUtils.buildVimPluginFrom2Nix rec {
      name = "silicon.lua";
      version = "774bca8aa58f026c6d43ec2f92faa88509be1c87";
      src = super.fetchFromGitHub {
        owner = "narutoxy";
        repo = "silicon.lua";
        rev = version;
        hash = "sha256-sjLR5CVC+bdlGD1t3QqlKFWhNgTJV0jxXFkAcIG8YYM=";
      };
    };
  };
in {
  vimPlugins = super.vimPlugins // plugin;
}
