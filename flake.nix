{
  description = "My julia2nix Env";
  inputs = {
    devshell-flake = { url = "github:numtide/devshell"; };
    nixpkgs = { url = "nixpkgs/7d71001b796340b219d1bfa8552c81995017544a"; };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };
  outputs = { self, nixpkgs, flake-utils, devshell-flake, flake-compat }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              devshell-flake.overlay
            ];
          };
        in
        {
          devShell = with pkgs;
            let
              custom-python-env = pkgs.python3.buildEnv.override
                {
                  extraLibs = with pkgs.python3Packages; [ xlrd ];
                  ignoreCollisions = true;
                };
            in
            devshell.mkShell {
              imports = [
                (devshell.importTOML ./commands.toml)
              ];
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
            };
        }
      )
    );
}
