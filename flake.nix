{
  description = "Python library for macro expansion";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        python_packages = python.withPackages (ps: with ps; [
          setuptools
          wheel
        ]);
      in

      {
        packages.default = with import nixpkgs { inherit system; };
          python3Packages.buildPythonApplication rec {
            pname = "pyexpander";
            version = "2.1.2";

            src = fetchPypi {
              inherit pname version;
              hash = "sha256:a1ad4804851bf99fcfd467d8ad46308d6aa05cc36f6f443232cd059dada05e84";
            };

            pyproject = true;

            nativeBuildInputs = [
              python_packages
            ];

            # buildPhase = "tar -xzf pyexpander-2.1.2.tar.gz";
            # installPhase = "mkdir -p $out/bin; ";
            postFixup = "cp $out/bin/expander.py $out/bin/pyexpander";

            meta = {
              description = "Python library for macro expansion";
              homepage = "https://pyexpander.sourceforge.io/introduction.html";
              license = lib.licenses.gpl3;
              maintainers = [ "Goetz Pfeiffer" ];
            };
          };

      }
    );
}
