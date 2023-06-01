self: super:

{
  signal-desktop = super.signal-desktop.overrideAttrs (old: {
    preFixup = ''
      ${old.preFixup}

      substituteInPlace $out/share/applications/${old.pname}.desktop \
        --replace $out/bin/${old.pname} "$out/bin/${old.pname} --use-tray-icon"
    '';
  });
}
