inputs:
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
    inputs.nixpkgs-julia.legacyPackages.${pkgs.system}.julia_18.withPackages
      [
        "Plots"
        "JSON3"
        "Pluto"
      ]
  ;
in
{
  options.project = lib.mkOption {
    internal = true;
    type =
      let
        projects = l.attrNames (l.readDir (inputs.self + "/playground"));
      in
      l.types.enum projects
    ;
    description = "Project to run";
  };
  config = {
    devshell.startup.link-project = {
      deps = [ ];
      text = ''
        ln -sf $PRJ_ROOT/playground/${config.project}/*.toml $PRJ_ROOT/.
      '';
    };
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
      help = "julia with packages from nixpkgs-julia PR";
    } ];
  };
}
