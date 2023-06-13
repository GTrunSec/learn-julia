{
  description = "Flops";

  inputs.std.url = "github:divnix/std";
  inputs.nixpkgs.follows = "std/nixpkgs";
  inputs.nixfmt.url = "github:serokell/nixfmt/?ref=refs/pull/118/head";
  inputs.nixfmt.inputs.nixpkgs.follows = "nixpkgs";
  inputs.call-flake.url = "github:divnix/call-flake";

  outputs =
    {
      std,
      ...
    }@inputs:
    std.growOn
      {
        inputs = inputs // { local = inputs.call-flake ../.; };
        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; [
          # Development Environments
          (nixago "configs")
          (devshells "devshells")
        ];
      }
      {
        devShells = std.harvest inputs.self [
          "automation"
          "devshells"
        ];
      }
    ;
}
