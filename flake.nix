{
  description = "julia2nix DevEnv";
  inputs = {
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    julia2nix.url = "github:JuliaCN/julia2nix";
    nixpkgs-julia.url = "github:NixOS/nixpkgs/?ref=refs/pull/225513/head";
    call-flake.url = "github:divnix/call-flake";
  };
  outputs =
    {
      self,
      flake-parts,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      local = inputs.call-flake ./nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;
      flake = {
        inherit (local) __std;
        devshellModules.devshell = import ./nix/devshell.nix inputs;
        overlays = import ./nix/overlays.nix { inherit inputs; };
      };
      perSystem =
        {
          config,
          pkgs,
          inputs',
          self',
          ...
        }: {
          _module.args.pkgs = import inputs.nixpkgs {
            overlays = [ self.overlays.default ];
          };
          devShells.default = local.devShells.${pkgs.system}.default;
        }
        ;
    }
    ;
}
