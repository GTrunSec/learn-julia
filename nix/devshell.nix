nixpkgs-julia:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  l = lib // builtins;
  custom-python-env = pkgs.python3.buildEnv.override {
    extraLibs = with pkgs.python3Packages; [ xlrd ];
    ignoreCollisions = true;
  };
  juliaWithPakcges =
    nixpkgs-julia.legacyPackages.${pkgs.system}.julia_18.withPackages
      [
        "Plots"
        "JSON3"
        "Pluto"
      ]
    ;
in
{
  packages = with pkgs; [ julia-wrapped ];
  env = [
    {
      name = "PYTHON";
      value = "${custom-python-env}/bin/python";
    }
    {
      name = "PYTHONPATH";
      value = "${custom-python-env}/${pkgs.python3.sitePackages}";
    }
  ];
  commands = with pkgs; [ {
    name = "juliaWithPakcges";
    command = l.getExe juliaWithPakcges;
  } ];
}
