{inputs}: {
  default = final: prev:  {
    julia-wrapped = inputs.julia2nix.lib.${prev.system}.julia-wrapped {
      package = inputs.julia2nix.packages.${prev.system}.julia_18-bin;
      meta.mainProgram = "julia-bin";
      enable = {
        GR = true;
      };
      makeWrapperArgs = ["--add-flags" "-L''${../startup.jl}"];
    };
  };
}
