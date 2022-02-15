{
  description = "My julia2nix Env";
  inputs = {
    devshell = { url = "github:numtide/devshell"; };
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, devshell }@inputs:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [ devshell.overlay ];
        in
        {
          devShell = import ./shell { inherit inputs pkgs self; };
        }
      )
    );
}
