# Fermyon Spin
# https://github.com/fermyon/spin

{ stdenv, fetchurl, ... }:

let 
  version = "v0.3.0";
  arch = "macos-aarch64";
  asset = "spin-${version}-${arch}.tar.gz";
  sha256 = "sha256-Ea+xBjpbBrvdxaoO0zRfnjLKQU+imtb/9mt5VhT9G6c=";
in 
  stdenv.mkDerivation {
    pname = "spin";
    inherit version;
    src = fetchurl {
      url = "https://github.com/fermyon/spin/releases/download/${version}/${asset}";
      inherit sha256;
    };

    unpackPhase = ''
      runHook preUnpack
      tar xvf $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp spin $out/bin/spin 
      runHook postInstall
      '';
  }
