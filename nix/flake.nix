{
  inputs.nixpkgs.url =
    "github:NixOS/nixpkgs/6b1b72c0f887a478a5aac355674ff6df0fc44f44";
  inputs.std.url = "github:divnix/std";
  inputs.std.inputs.nixpkgs.follows = "nixpkgs";
  inputs.std.inputs.devshell.follows = "devshell";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.nixfmt.url = "github:serokell/nixfmt/?ref=refs/pull/118/head";
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
              self: super: { inputs = { local = inputs.call-flake ../.; }; }
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
