{ inputs }:
{
  default = final: prev: {
    julia-wrapped = inputs.julia2nix.lib.${prev.system}.julia-wrapped {
      package = inputs.julia2nix.packages.${prev.system}.julia_19-bin;
      meta.mainProgram = "julia";
      enable = {
        GR = true;
      };
      # makeWrapperArgs = ["--add-flags" "-L''${../startup.jl}"];
    };
  };
}
