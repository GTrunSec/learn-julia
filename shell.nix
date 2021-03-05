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
        ${pkgs.git}/bin/git clone https://github.com/GTrunSec/julia2nix.git -b extraBuildInputs
        fi
        julia2nix/julia2nix && nix-build
        $(nix-build . --no-out-link)/bin/julia -e 'import Pkg; Pkg.instantiate()'
      '';
      category = "julia2nix";
      help = "generate the Julia Pkg's Nix expression and build Packages";
    }
    {
      name = "julia";
      command = "$(nix-build . --no-out-link)/bin/julia";
      category = "julia";
      help = "wrapped Julia executable";
    }
    {
      name = "pluto";
      command = ''
        $(nix-build . --no-out-link)/bin/julia -e 'import Pkg; Pkg.activate("."); using Pluto; Pluto.run(host=" 10.220.170.112", port=8889)'
      '';
      category = "julia_package";
      help = "launch pluto server";
    }
    {
      name = "addPackage";
      command = ''
        rm -rf $JULIA_DEPOT_PATH
        eval $(echo "$(nix-build . --no-out-link)/bin/julia -e 'using Pkg; Pkg.activate(\"$1\"); Pkg.add([$2])'")
        # cleanup JULIA_DEPOT_PATH for Julia2nix Build
      '';
      category = "julia_package";
      help = ''
        Exp: addPackage . '\"StatsFuns, Images\"' -> <activatePath> <Package Name List>
      '';
    }
  ];
}
