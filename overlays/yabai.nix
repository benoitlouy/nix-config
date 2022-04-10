self: super:

{
  yabai = super.yabai.overrideAttrs (
    old: rec {
      version = "4.0.0";

      src = self.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-CBoRyxrleCKzgwZQamhwh3zkotxZCHrL3tslfktxluc=";
      };
    }
  );
}
