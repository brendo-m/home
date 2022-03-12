with import <nixpkgs> {};

let
  base-python-packages = python-packages: with python-packages; [
    setuptools
    pip
    pipx

    # localstack
    dateutil
    jmespath
    pbr
    botocore
  ];
in
  python39.withPackages base-python-packages