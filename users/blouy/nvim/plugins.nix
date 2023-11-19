{ buildVimPlugin, fetchFromGitHub }:

{
  bufterm = buildVimPlugin {
    name = "bufterm";
    src = fetchFromGitHub {
      owner = "boltlessengineer";
      repo = "bufterm.nvim";
      rev = "7aae848dff66a24425b4dcaf0567c4620edf45be";
      hash = "sha256-m/1PhcVoL46v/Q0sxwiw9MmCH3h+dDXvSPDjjEPDkjU=";
    };
  };
}
