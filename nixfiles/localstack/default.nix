{ pkgs }:

let
  # First break the circular dependency on localstack in our poetry lockfile.
  localstack-wrapper-src = pkgs.stdenv.mkDerivation {
    name = "localstack-wrapper-patched-src";
    src = ./.;
    buildInputs = [ pkgs.gnused ];
    # Note: This crudely deletes all instances where a package depends on localstack.
    # In our case this is only localstack-ext. This might need to me modified for other cases.
    buildPhase = ''
      sed -r -i '/^localstack = ".+"$/d' poetry.lock
    '';
    installPhase = "cp -r . $out/";
  };

  localstack-wrapper = pkgs.poetry2nix.mkPoetryApplication {
    projectDir = localstack-wrapper-src;
    src = localstack-wrapper-src;
    python = pkgs.python39;
    overrides = [
      pkgs.poetry2nix.defaultPoetryOverrides
      (self: super: {
        plux = super.plux.overridePythonAttrs
          (old: { buildInputs = old.buildInputs ++ [ self.pytestrunner ]; });
        localstack-ext = super.localstack-ext.overridePythonAttrs (old: {
          doCheck = false;
          # Need to again hack out the localstack dependency from localstack-ext otherwise
          # it will complain during the installPhase.
          postPatch = ''
            sed -r -i '/^\s*localstack.+$/d' setup.cfg
          '';
        });
      })
    ];
  };
in localstack-wrapper