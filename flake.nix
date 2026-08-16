{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        haskellPackages = pkgs.haskellPackages; 

        hakyllProject = haskellPackages.callCabal2nix "hakyll-site" ./. {};

      in {
        packages.default = hakyllProject;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ hakyllProject.env ];
          
          buildInputs = with haskellPackages; [
            cabal-install
            haskell-language-server
            stack
          ] ++ (with pkgs; [
            zlib
          ]);

        };
      }
    );
}
