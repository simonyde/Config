{ pkgs, lib, fetchFromGitHub }:

with pkgs.python3Packages;

buildPythonApplication rec {
  pname = "grawlix";
  version = "7d63f17";

  src = fetchFromGitHub {
    owner = "jo1gi";
    repo = pname;
    rev = version;
    sha256 = "sha256-C9tTCMIJdZaoHVXysz+0Mj7k1dWNtnfVqMNs4+nYWlk=";
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    blackboxprotobuf
    ebooklib
    httpx
    importlib-resources
    lxml
    pycryptodome
    rich
    tomli

    # Test
    pytest
    mypy
    types-requests
    types-setuptools

    # Build
    build
    setuptools
    twine
    
    (python3Packages.buildPythonPackage rec {
      pname = "EbookLib";
      version = "0.18";
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-OFYmQ6e8lNm/VumTC0kn5Ok7XR0JF/aXpkVNtaHBpTM=";
      };
      propagatedBuildInputs = with python3Packages; [
        six
        lxml
      ];
    })
    (python3Packages.buildPythonPackage rec {
      pname = "blackboxprotobuf";
      version = "1.0.1";

      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-IztxTmwkzp0cILhxRioiCvkXfk/sAcG3l6xauGoeHOo=";
      };

      propagatedBuildInputs = with python3Packages; [
        protobuf
      ];

      patchPhase = ''
        sed 's/protobuf==3.10.0/protobuf/' requirements.txt > requirements.txt
      '';

      doCheck = false;
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "eBook cli downloader";
    homepage = "https://github.com/jo1gi/grawlix";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
