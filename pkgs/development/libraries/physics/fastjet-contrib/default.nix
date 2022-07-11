{ lib, stdenv, fetchurl, fastjet }:

stdenv.mkDerivation rec {
  pname = "fastjet-contrib";
  version = "1.048";

  src = fetchurl {
    url = "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-${version}.tar.gz";
    sha256 = "sha256-+ZidO2rrIoSLz5EJXDBgfwJ9PvJ3pPD3BKjw/C52aYE=";
  };

  buildInputs = [ fastjet ];

  postPatch = ''
    for f in Makefile.in */Makefile; do
      substituteInPlace "$f" --replace "CXX=g++" ""
    done
    patchShebangs ./configure ./utils/check.sh ./utils/install-sh
  '';

  # Written in shell manually, does not support autoconf-style
  # --build=/--host= options:
  #   Error: --build=x86_64-unknown-linux-gnu: unrecognised argument
  configurePlatforms = [ ];

  enableParallelBuilding = true;

  doCheck = true;

  postBuild = ''
    make fragile-shared
  '';

  postInstall = ''
    make fragile-shared-install
  '';

  meta = with lib; {
    description = "Third party extensions for FastJet";
    homepage = "http://fastjet.fr/";
    changelog = "https://phab.hepforge.org/source/fastjetsvn/browse/contrib/tags/${version}/NEWS?as=source&blame=off";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
