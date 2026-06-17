{
  description = "Hakyll static site flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
            ghcid 
          ] ++ (with pkgs; [
            zlib
          ]);

        };
      }
    );
}
