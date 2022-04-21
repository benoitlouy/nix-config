self: super:

let
  version = "1.9.0";
  binName = "jdt-language-server-1.9.0-202203031534";

  src = super.fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/${version}/${binName}.tar.gz";
    hash = "sha256-uK8ZJcs7gX/RBh4ApF/7xqynaBnYsvWTliYAnr9DL8c=";
    # sha256 = "68378599cca158f7aab4d54782efcda9258ef98389ba7757c68d59284ed69672";
  };

  jdtls = super.stdenv.mkDerivation rec {

    name = "eclipse-jdt-language-server-${version}";
    inherit src;

    sourceRoot = ".";

    installPhase = ''
      mkdir -p "$out/jdtls"
      cp -R config_mac config_ss_mac "config_linux" "config_ss_linux" "features" "plugins" "$out/jdtls"
    '';

    meta = with super.lib; {
      homepage = "https://github.com/eclipse/eclipse.jdt.ls";
      description = "Eclipse JDT Language Server";
      longDescription = ''
        The Eclipse JDT Language Server is a Java language specific implementation of the Language Server Protocol
        and can be used with any editor that supports the protocol, to offer good support for the Java Language.
      '';
      # platforms = platforms.linux;
      maintainers = with maintainers; [ marc-jakobi ];
    };

  };

  jdtlsWrapper = super.writeShellScriptBin "jdtls" ''
      exec ${self.jdk}/bin/java \
        -Declipse.application=org.eclipse.jdt.ls.core.id1 \
        -Dosgi.bundles.defaultStartLevel=4 \
        -Declipse.product=org.eclipse.jdt.ls.core.product \
        -Dosgi.checkConfiguration=true \
        -Dosgi.sharedConfiguration.area=${jdtls}/jdtls/config_mac \
        -Dosgi.sharedConfiguration.area.readOnly=true \
        -Dosgi.configuration.cascaded=true \
        -noverify \
        -Xms1G \
        -jar ${jdtls}/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
        "$@"
    '';

in
{
  eclipse-jdt-ls = super.symlinkJoin {
    name = "jdtls";
    paths = [ jdtls jdtlsWrapper ];
  };
}
