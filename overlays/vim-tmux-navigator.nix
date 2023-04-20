self: super:

let
  plugin = {
    vim-tmux-navigator = super.tmuxPlugins.mkTmuxPlugin {
      pluginName = "vim-tmux-navigator";
      rtpFilePath = "vim-tmux-navigator.tmux";
      version = "unstable-2022-08-21";
      src = super.fetchFromGitHub {
        owner = "christoomey";
        repo = "vim-tmux-navigator";
        rev = "afb45a55b452b9238159047ce7c6e161bd4a9907";
        hash = "sha256-8A+Yt9uhhAP76EiqUopE8vl7/UXkgU2x000EOcF7pl0=";
      };
    };
  };
in
{
  tmuxPlugins = super.tmuxPlugins // plugin;
}
