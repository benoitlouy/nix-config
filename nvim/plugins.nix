{ buildVimPluginFrom2Nix, fetchFromGitHub }:

{
  nvim-metals = buildVimPluginFrom2Nix {
    name = "nvim-metals";
    src  = fetchFromGitHub {
      owner  = "scalameta";
      repo   = "nvim-metals";
      rev    = "de28e5d16e88fc88b3246c4ecbaa8e876d9e0c6d";
      sha256 = "1659mjf2z72g5nrwb430j8yqv39ih3fvc247v1gpf61gdgzvziix";
      # rev    = "69a5cf9380defde5be675bd5450e087d59314855";
      # sha256 = "1kjr7kgwvg1c4gglipmasvpyrk4gar4yi9kd8xdfqyka9557vyy9";
    };
  };
}
