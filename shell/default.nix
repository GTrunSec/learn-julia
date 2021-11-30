{ self, inputs, pkgs, ... }:
with pkgs;
let
  reboudBud = inputs.bud self;
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
  commands = with pkgs; [
    {
      category = "julia2nix";
      package = reboudBud {
        inherit pkgs inputs;
        name = "julia2nix";
        budStdProfile = false;
      };
    }
  ];
  # tempfix: remove when merged https://github.com/numtide/devshell/pull/123
  devshell.startup.load_profiles = pkgs.lib.mkForce (pkgs.lib.noDepEntry ''
    # PATH is devshell's exorbitant privilige:
    # fence against its pollution
    _PATH=''${PATH}
    # Load installed profiles
    for file in "$DEVSHELL_DIR/etc/profile.d/"*.sh; do
      # If that folder doesn't exist, bash loves to return the whole glob
      [[ -f "$file" ]] && source "$file"
    done
    # Exert exorbitant privilige and leave no trace
    export PATH=''${_PATH}
    unset _PATH
  '');
}
