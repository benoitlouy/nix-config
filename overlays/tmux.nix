self: super:

{
  tmux = super.tmux.overrideAttrs
    (
      old: rec {
        version = "3.0a";
        patches = [];
        src = super.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = version;
          sha256 = "0y9lv1yr0x50v3k70vzkc8hfr7yijlsi30p7dr7i8akp3lwmmc7h";
          # sha256 = "1fqgpzfas85dn0sxlvvg6rj488jwgnxs8d3gqcm8lgs211m9qhcf";
          # sha256 = "sha256-jkGcaghCP4oqw280pLt9XCJEZDZvb9o1sK0grdy/D7s=";
          # sha256 = "sha256-SygHxTe7N4y7SdzKixPFQvqRRL57Fm8zWYHfTpW+yVY=";
        };
      }
    );
}
