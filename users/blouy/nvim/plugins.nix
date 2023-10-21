{ buildVimPlugin, fetchFromGitHub }:

{
  bufterm = buildVimPlugin {
    name = "bufterm";
    src  = fetchFromGitHub {
      owner  = "boltlessengineer";
      repo   = "bufterm.nvim";
      rev    = "69f1894834f71c2be60b0920542f12455fbd36c5";
      hash   = "sha256-iqycAHttPB2h73ua4FTCmQTGYC9Xj16GVZNRyPOBrJk=";
    };
  };
}
