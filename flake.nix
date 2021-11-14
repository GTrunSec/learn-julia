{
  description = "My julia2nix Env";
  inputs = {
    devshell = { url = "github:numtide/devshell"; };
    nixpkgs = { url = "nixpkgs/release-21.05"; };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    bud = {
      url = "github:gtrunsec/bud/custom";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
    };
  };
  outputs = { self, nixpkgs, flake-utils, devshell, flake-compat, bud }@inputs:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              devshell.overlay
            ];
            config = { };
          };
        in
        {
          devShell = import ./shell { inherit inputs pkgs self; };
        }
      )
    ) //
    {
      budModules =
        {
          julia2nix = import ./shell/julia2nix;
        };
    };
}
