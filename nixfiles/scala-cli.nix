{ stdenv, fetchurl, ... }:

# based on https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/build-managers/scala-cli/default.nix
# which doesn't work for M1
let 
  version = "0.1.1";
  asset = "scala-cli-x86_64-apple-darwin.gz";
  sha256 = "sha256-wULC0/n0ZFdBXOjxVe/VYsdsGBorNd51HczCK20Pmwc=";
in
  stdenv.mkDerivation {
    pname = "scl";
    inherit version;
    src = fetchurl {
      url = "https://github.com/Virtuslab/scala-cli/releases/download/v${version}/${asset}";
      inherit sha256;
    };

    unpackPhase = ''
      runHook preUnpack
      gzip -d < $src > scl
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 scl $out/bin/scl
      runHook postInstall
    '';

    # # We need to call autopatchelf before generating completions
    # dontAutoPatchelf = true;

    # postFixup = ''
    #   autoPatchelf $out
    #   # hack to ensure the completion function looks right
    #   # as $0 is used to generate the compdef directive
    #   PATH="$out/bin:$PATH"
    #   installShellCompletion --cmd scl --zsh <(scl completions zsh)
    # '';
  }