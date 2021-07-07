{
  description = "My julia2nix Env";
  inputs = {
    devshell-flake = { url = "github:numtide/devshell"; };
    nixpkgs = { url = "nixpkgs/release-21.05"; };
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
                (devshell.importTOML ./devshell.toml)
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
