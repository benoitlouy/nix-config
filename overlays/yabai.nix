self: super:

{
  yabai = super.yabai.overrideAttrs (
    old: rec {
      version = "4.0.4";

      src = self.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-NS8tMUgovhWqc6WdkNI4wKee411i/e/OE++JVc86kFE=";
      };
    }
  );
}
