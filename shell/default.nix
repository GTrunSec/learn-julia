{ self, inputs, pkgs, ... }:
with pkgs;
let
  custom-python-env = pkgs.python3.buildEnv.override
    {
      extraLibs = with pkgs.python3Packages; [ xlrd ];
      ignoreCollisions = true;
    };
in
pkgs.devshell.mkShell {
  imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
  packages = with pkgs;[ ];
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
  commands = with pkgs; [  ];
}
