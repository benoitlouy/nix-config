self: super:

{
  yabai = super.yabai.overrideAttrs (
    old: rec {
      version = "5.0.1";

      src = self.fetchzip {
        url = "https://github.com//koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-iCx/e3IwJ6YzgEy7wGkNQU/d7gaZd4b/RLwRvRpwVwQ=";
      };
    }
  );
}
