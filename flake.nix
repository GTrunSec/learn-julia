{
  description = "My julia2nix Env";
  inputs = {
    devshell.url = "github:numtide/devshell";
    nixpkgs = { url = "nixpkgs/7d71001b796340b219d1bfa8552c81995017544a"; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, devshell }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          devShell = import ./shell.nix { inherit nixpkgs; };
        }
      )
    );
}
