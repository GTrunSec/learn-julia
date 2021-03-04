{ system ? builtins.currentSystem
, ...
}:
let
  fetch = import ./compat/fetch.nix;
  devshell' = fetch "devshell";
  pkgs = import (fetch "nixpkgs") { };
  devshell = import devshell' {
    inherit system;
  };
in
devshell.mkShell rec {
  name = "my-julia2nix-env";
  packages = with pkgs;
    [ ];

  env = [
    {
      name = "JULIA_DEPOT_PATH";
      value = "./.julia_depot";
    }
    {
      name = "PATH";
      prefix = "bin";
    }
    {
      name = "JuliaBin";
      value = "$(nix-build . --no-out-link)/bin/julia";
    }
  ];
  commands = with pkgs; [
    {
      name = "julia2nix";
      command = ''
        if [ ! -d  "./julia2nix" ]; then
        ${pkgs.git}/bin/git clone https://github.com/thomasjm/julia2nix.git
        fi
        julia2nix/julia2nix && nix-build
      '';
      category = "julia2nix";
    }
    {
      name = "julia";
      command = "$(nix-build . --no-out-link)/bin/julia";
      category = "julia";
    }
    {
      name = "pluto";
      command = ''
        $(nix-build . --no-out-link)/bin/julia -e 'using Pluto; Pluto.run(host=" 10.220.170.112", port=8889)'
      '';
      category = "julia_package";
    }
  ];
}
