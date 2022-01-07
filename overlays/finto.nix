self: super:

{
  finto = super.buildGoModule rec {
    pname = "finto";
    version = "0.1.0";

    src = super.fetchFromGitHub {
      owner = "benoitlouy";
      repo = "finto";
      rev = "d54f53b8ff35ea34e6738e47c2724f57dd44d014";
      sha256 = "00rlwnjx0c3g0klm3dyhi9ch53bm5ks7afqd1scgl2pd4g11hr0y";
    };

    vendorSha256 = "017n977ix0zv8l2p7c8vzpw3913mz4i336x04lmqmfgbpki18cr2";

    runVend = true;

    meta = with super.lib; {
      description = "web server that emulates EC2 instance profile roles";
      homepage = "https://github.com/threadwaste/finto";
      license = licenses.mit;
      platforms = platforms.linux ++ platforms.darwin;
    };
  };
}
