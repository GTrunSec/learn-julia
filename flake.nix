{
  description = "My julia2nix Env";
  inputs = {
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    #julia2nix.url = "github:JuliaCN/julia2nix";
    julia2nix.url = "/home/gtrun/ghq/github.com/JuliaCN/julia2nix";
  };
  outputs = {self, ...} @ inputs: (
    inputs.flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages."${system}".appendOverlays [
          inputs.devshell.overlay
          self.overlays.default
        ];
      in {
        devShell = import ./devshell {inherit inputs pkgs;};
      }
    )
    // {
      overlays = import ./nix/overlays.nix { inherit inputs; };
    }
  );
}
