{
  inputs,
  pkgs,
}:
with pkgs; let
  custom-python-env =
    pkgs.python3.buildEnv.override
    {
      extraLibs = with pkgs.python3Packages; [xlrd];
      ignoreCollisions = true;
    };
in
  pkgs.devshell.mkShell {
    imports = [
      (pkgs.devshell.importTOML ./devshell.toml)
      # inputs.julia2nix.${pkgs.system}.julia2nix.devshellProfiles.packages
    ];
    packages = with pkgs; [
      julia-wrapped
    ];
    env = [
      {
        name = "SSL_CERT_FILE";
        value = "${cacert}/etc/ssl/certs/ca-bundle.crt";
      }
      {
        name = "PYTHON";
        value = "${custom-python-env}/bin/python";
      }
      {
        name = "PYTHONPATH";
        value = "${custom-python-env}/${pkgs.python3.sitePackages}";
      }
];
    commands = with pkgs; [];
  }
