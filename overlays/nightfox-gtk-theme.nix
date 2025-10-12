self: super:

let
  colorVariants = [];
  sizeVariants = [ "compact" ];
  themeVariants = [];
  tweakVariants = [ "carbonfox" "black" ];
  iconVariants = [];
in
{
  nightfox-gtk-theme-fix = super.stdenvNoCC.mkDerivation
  {
    pname = "nightfox-gtk-theme-fix";
    version = "0-unstable-2025-09-09";

    src = super.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Nightfox-GTK-Theme";
      rev = "7672385bb28e39c65d1509f15efbe1a7c1bde631";
      hash = "sha256-Rd8GkXeyrX3fYoYOO+1GN8MLg2+vW3BsXcbBraAL+Is=";
    };

    propagatedUserEnvPkgs = [ super.gtk-engine-murrine ];

    nativeBuildInputs = [ super.sassc ];
    buildInputs = [ super.gnome-themes-extra ];

    dontBuild = true;

    passthru.updateScript = super.unstableGitUpdater { };

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Nightfox \
      ${super.lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${super.lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${super.lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${super.lib.optionalString (tweakVariants != [ ]) "--tweaks " + toString tweakVariants} \
      -d "$out/share/themes"
      cd ../icons
      ${super.lib.optionalString (iconVariants != [ ]) ''
        mkdir -p $out/share/icons
        cp -a ${toString (map (v: "${v}") iconVariants)} $out/share/icons/
      ''}
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Nightfox colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Nightfox-GTK-Theme";
      license = super.lib.licenses.gpl3Plus;
      platforms = super.lib.platforms.unix;
      maintainers = with super.lib.maintainers; [ d3vil0p3r ];
    };
  };
}
