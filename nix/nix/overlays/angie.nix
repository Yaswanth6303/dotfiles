# Overlay to build Angie web server (NGINX-compatible fork) from source
final: prev: {
  angie = prev.stdenv.mkDerivation rec {
    pname = "angie";
    version = "1.5.2";

    src = prev.fetchurl {
      url = "https://download.angie.software/files/angie-${version}.tar.gz";
      sha256 = "sha256-hdC26MiLw2mOiBZicneSeIVcTFDlZZjFCgiXfDu/NF4=";
    };

    nativeBuildInputs = [ prev.gnumake ];

    buildInputs = [
      prev.pcre2
      prev.zlib
      prev.openssl
    ];

    configurePhase = ''
      ./configure \
        --prefix=$out \
        --with-http_ssl_module \
        --with-http_v2_module
    '';

    buildPhase = "make";
    installPhase = "make install";

    meta = with prev.lib; {
      description = "Angie web server (NGINX-compatible fork)";
      homepage = "https://angie.software";
      platforms = platforms.darwin;
    };
  };
}
