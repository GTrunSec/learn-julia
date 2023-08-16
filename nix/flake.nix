{
  inputs.nixpkgs.follows = "std-ext/nixpkgs";
  inputs.std-ext.url = "github:gtrunsec/std-ext";
  inputs.std.follows = "std-ext/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.call-flake.url = "github:divnix/call-flake";
  inputs.flops.url = "github:gtrunsec/flops";

  outputs =
    { flops, ... }@inputs:
    let
      inherit (flops.inputs) POP;
      inherit (flops.lib.flake) pops;
      __inputs__ =
        (((pops.default.setInitInputs inputs).addInputsExtender (
          POP.lib.extendPop pops.inputsExtender (
            self: super: {
              inputs = {
                local = inputs.call-flake ../.;
              };
            }
          )
        )).addInputsOverrideExtender
          (
            POP.lib.extendPop pops.inputsExtender (
              self: super: {
                overrideInputs = {
                  # nixpkgs-override.locked = self.initInputs.local.inputs.nixpkgs.sourceInfo;
                  # std.inputs.nixpkgs = "nixpkgs-override";
                };
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
          (devshells "shells")
        ];
      }
      {
        devShells = std.harvest inputs.self [
          "dev"
          "shells"
        ];
      };
}
