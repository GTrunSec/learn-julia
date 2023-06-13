/* This file holds reproducible shells with commands in them.

   They conveniently also generate config files in their startup hook.
*/
{
  inputs,
  cell,
}:
let
  inherit (inputs.std) lib;
  inherit (inputs) std;
  nixpkgs = inputs.local.nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "Julia Development Shell";
    _module.args.pkgs = nixpkgs;
    imports = [
      (
        import (inputs.local + "/nix/devshell.nix")
          inputs.local.inputs.nixpkgs-julia
      )
      (std.inputs.devshell.lib.importTOML (inputs.local + "/devshell.toml"))
      inputs.local.inputs.julia2nix.${nixpkgs.system}.julia2nix.devshellProfiles.dev
    ];
    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      lib.cfg.conform
      (lib.cfg.treefmt cell.configs.treefmt)
      (lib.cfg.editorconfig cell.configs.editorconfig)
      (lib.cfg.githubsettings cell.configs.githubsettings)
      (lib.cfg.lefthook cell.configs.lefthook)
    ];

    commands = [ ];
    # packages = [ nixpkgs.rustEnv ];
  };
}
