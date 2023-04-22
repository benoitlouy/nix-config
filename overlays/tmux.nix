self: super:

{
  tmux = super.tmux.overrideAttrs
    (
      old: rec {
        version = "3.1c";
        patches = [];
        src = super.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = version;
          hash = "sha256-jkGcaghCP4oqw280pLt9XCJEZDZvb9o1sK0grdy/D7s=";
        };
      }
    );
}
