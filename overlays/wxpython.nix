self: super:

{
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (pyfinal: pyprev: {
      wxpython = pyprev.wxpython.overrideAttrs (old: {
        disabled = false;
        postPatch =
          let
            waf_2_0_25 = super.fetchurl {
              url = "https://waf.io/waf-2.0.25";
              hash = "sha256-IRmc0iDM9gQ0Ez4f0quMjlIXw3mRmcgnIlQ5cNyOONU=";
            };
          in
          ''
            cp ${waf_2_0_25} bin/waf-2.0.25
            chmod +x bin/waf-2.0.25
            substituteInPlace build.py \
              --replace-fail "wafCurrentVersion = '2.0.24'" "wafCurrentVersion = '2.0.25'" \
              --replace-fail "wafMD5 = '698f382cca34a08323670f34830325c4'" "wafMD5 = 'a4b1c34a03d594e5744f9e42f80d969d'" \
              --replace-fail "distutils.dep_util" "setuptools.modified"
          '';
      });
    })
  ];
}
