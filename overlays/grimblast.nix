self: super:

let
  capture-area = super.makeDesktopItem {
    name = "capture-area";
    exec = "${super.grimblast}/bin/grimblast --notify copy area";
    desktopName = "Capture Area";
    icon = "camera";
  };
  capture-area-save = super.makeDesktopItem {
    name = "capture-area-save";
    exec = "${super.grimblast}/bin/grimblast --notify save area";
    desktopName = "Capture Area and Save";
    icon = "camera";
  };
  capture-screen = super.makeDesktopItem {
    name = "capture-screen";
    exec = "${super.grimblast}/bin/grimblast --notify copy output";
    desktopName = "Capture Screen";
    icon = "camera";
  };
  capture-screen-save = super.makeDesktopItem {
    name = "capture-screen-save";
    exec = "${super.grimblast}/bin/grimblast --notify save output";
    desktopName = "Capture Screen and Save";
    icon = "camera";
  };
in
{
  grimblast-desktop-items = super.stdenv.mkDerivation {
    pname = "grimblast-desktop-items";
    version = "1.0.0";

    unpackPhase = ":";

    nativeBuildInputs = [ super.copyDesktopItems ];

    desktopItems = [
      capture-area
      capture-area-save
      capture-screen
      capture-screen-save
    ];
  };
}

