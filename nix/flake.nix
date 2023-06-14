{
  inputs.blank.follows = "std/blank";
  inputs.std.url = "github:divnix/std";
  # inputs.nixpkgs.follows = "blank";
  inputs.nixpkgs.follows = "std/nixpkgs";
  # inputs.std.inputs.nixpkgs.follows = "nixpkgs";

  inputs.std.inputs.devshell.follows = "devshell";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.nixfmt.url = "github:serokell/nixfmt/?ref=refs/pull/118/head";
  inputs.nixfmt.inputs.nixpkgs.follows = "nixpkgs";
  inputs.call-flake.url = "github:divnix/call-flake";
  inputs.flops.url = "github:gtrunsec/flops";

  outputs =
    {
      flops,
      ...
    }@inputs:
    let
      inherit (flops.inputs) POP nixlib;
      inherit (flops.lib.flake) pops;
      __inputs__ =
        (
          ((pops.default.setInitInputs inputs).addInputsExtender (
            POP.lib.extendPop pops.inputsExtender (
              self: super: {
                inputs = {
                  nixpkgs = self.inputs.local.inputs.nixpkgs;
                  local = inputs.call-flake ../.;
                };
              }
            )
          )).addInputsOverrideExtender
            (
              POP.lib.extendPop pops.inputsExtender (
                self: super: {
                  # overrideInputs.std = { inputs.nixpkgs = self.inputs.nixpkgs; };
                }
              )
            )
        ).outputsForInputs;
      inherit (__inputs__) std;
    in
    std.growOn
      {
        inputs = __inputs__;
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
