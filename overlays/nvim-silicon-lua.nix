self: super:

let
  plugin = {
    silicon-lua = super.vimUtils.buildVimPluginFrom2Nix rec {
      name = "silicon.lua";
      version = "3223d26456f728870cacab91662d03bbace6e354";
      src = super.fetchFromGitHub {
        owner = "narutoxy";
        repo = "silicon.lua";
        rev = version;
        hash = "sha256-IIPaVouqCFdffUxleryRkzU9DpmNLpF1MthU+ZkvRBU=";
      };
    };
  };
in {
  vimPlugins = super.vimPlugins // plugin;
}
