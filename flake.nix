{
  description = "julia2nix DevEnv";
  inputs = {
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    julia2nix.url = "github:JuliaCN/julia2nix";
    nixpkgs-julia.url = "github:NixOS/nixpkgs/?ref=refs/pull/225513/head";
    call-flake.url = "github:divnix/call-flake";
  };
  outputs =
    {
      self,
      ...
    }@inputs:
    (
      inputs.flake-utils.lib.eachDefaultSystem (
        system:
        let
          nixpkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [
            inputs.devshell.overlays.default
            self.overlays.default
          ];
        in
        {
          inherit nixpkgs;
          devShells.default =
            (inputs.call-flake ./nix).devShells.${system}.default;
        }
      ) // {
        overlays = import ./nix/overlays.nix { inherit inputs; };
        __std = (inputs.call-flake ./nix).__std;
      }
    )
    ;
}
