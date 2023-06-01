self: super:

{
  syncthing-gtk = super.python3Packages.buildPythonApplication rec {
    version = "0.9.4.5";
    pname = "syncthing-gtk";

    src = super.fetchFromGitHub {
      owner = "syncthing-gtk";
      repo = "syncthing-gtk";
      rev = "${version}";
      hash = "sha256-CpQlibErgdEJRr2OLN1dUF7GmsFHcNYH8egcPtDrb5s=";
    };

    nativeBuildInputs = with super; [
      wrapGAppsHook
      # For setup hook populating GI_TYPELIB_PATH
      gobject-introspection
      pango
      gdk-pixbuf
      atk
      libnotify
    ];

    buildInputs = with super; [
      gtk3
      librsvg
      libappindicator-gtk3
      libnotify
      gnome.adwaita-icon-theme
      # Schemas with proxy configuration
      gsettings-desktop-schemas
    ];

    propagatedBuildInputs = with super.python3Packages; [
      python-dateutil
      pyinotify
      pygobject3
      bcrypt

    ] ++ [ super.cinnamon.nemo-python ];

    patches = [
      (super.substituteAll {
        src = ./syncthing-gtk.patch;
        killall = "${self.killall}/bin/killall";
        syncthing = "${self.syncthing}/bin/syncthing";
      })
    ];

    # repo doesn't have any tests
    doCheck = false;

    # setupPyBuildFlags = [ "build_py" "--nofinddaemon" "--nostdownloader" ];

    postPatch = ''
      substituteInPlace setup.py --replace 'version = subprocess.check_output(["git", "describe", "--tags"])' "version = '${version}'"
      substituteInPlace setup.py --replace 'version = version.decode("utf-8").strip("\n\r \t")' ""
      # substituteInPlace setup.py --replace "version = get_version()" "version = '${version}'"
      substituteInPlace scripts/syncthing-gtk --replace "/usr/share" "$out/share"
      substituteInPlace syncthing_gtk/app.py --replace "/usr/share" "$out/share"
      substituteInPlace syncthing_gtk/uisettingsdialog.py --replace "/usr/share" "$out/share"
      substituteInPlace syncthing_gtk/wizard.py --replace "/usr/share" "$out/share"
      substituteInPlace syncthing-gtk.desktop --replace "Exec=syncthing-gtk" "Exec=$out/bin/syncthing-gtk"
    '';

    meta = with super.lib; {
      description = "GTK3 & python based GUI for Syncthing";
      homepage = "https://github.com/syncthing/syncthing-gtk";
      license = licenses.gpl2;
      # broken = true;
      maintainers = with maintainers; [ ];
      platforms = self.syncthing.meta.platforms;
    };
  };
}
