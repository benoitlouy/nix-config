self: super:

let
  plugin = {
    diagnosticls-configs-nvim = super.vimUtils.buildVimPlugin rec {
      name = "diagnosticls-configs-nvim";
      version = "0.1.9";
      src = super.fetchFromGitHub {
        owner = "creativenull";
        repo = "diagnosticls-configs-nvim";
        rev = "v${version}";
        hash = "sha256-Ert2OmrJrIOVZdgGsxk1vSzwqMGOBpe2uaaMIJV+aWI=";
      };
    };
  };
in
{
  vimPlugins = super.vimPlugins // plugin;
}
