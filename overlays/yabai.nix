self: super:

{
  yabai = super.yabai.overrideAttrs (
    old: rec {
      version = "4.0.1";

      src = self.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-dQZw7Df69aSbcU9ot6f73H3VzZEgo2qpgUM6IJRxk60=";
      };
    }
  );
}
