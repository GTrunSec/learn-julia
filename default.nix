{ pkgs ? import (import ./lib/fetch.nix "nixpkgs") { } }:

with pkgs;
let
  # The base Julia version
  baseJulia = julia_15.overrideAttrs (oldAttrs: {
    doCheck = false;
    checkTarget = "";
  });


  # Extra libraries for Julia's LD_LIBRARY_PATH.
  # Recent Julia packages that use Artifacts.toml to specify their dependencies
  # shouldn't need this.
  # But if a package implicitly depends on some library being present, you can
  # add it here.
  extraLibs = [
    gcc9
    zlib

    which
    electron_11
  ];

  gr = import ./patch/gr.nix { inherit pkgs; };
  libsnappy = import ./patch/libsnappy.nix { inherit pkgs; };
  thrift = import ./patch/thrift.nix { inherit pkgs; };
  zlibPath = import ./patch/zlib.nix { inherit pkgs; };


  custom-python-env = python3.buildEnv.override
    {
      extraLibs = with python3Packages; [ xlrd ];
      ignoreCollisions = true;
    };
  # Wrapped Julia with libraries and environment variables.
  # Note: setting The PYTHON environment variable is recommended to prevent packages
  # from trying to obtain their own with Conda.
  julia = runCommand "julia-wrapped"
    {
      buildInputs = [ makeWrapper ];
    } ''
    mkdir -p $out/bin
    makeWrapper ${baseJulia}/bin/julia $out/bin/julia \
                --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLibs}" \
                --set GRDIR ${gr} \
                --set JULIA_NUM_THREADS 24 \
                --set PYTHON ${custom-python-env}/bin/python \
                --set PYTHONPATH ${custom-python-env}/${pkgs.python3.sitePackages}

  '';

in
callPackage ./common.nix {
  inherit julia;

  # Run Pkg.precompile() to precompile all packages?
  precompile = true;
  # Extra arguments to makeWrapper when creating the final Julia wrapper.
  # By default, it will just put the new depot at the end of JULIA_DEPOT_PATH.
  # You can add additional flags here.
  makeWrapperArgs = " ";

  extraBuildInputs = extraLibs;

  patchShell = ''
    cp -r ${libsnappy}/usr $out/packages/Snappy/*/deps/.
    cp -r ${zlibPath}/usr $out/packages/CodecZlib/*/deps/.
    cp -r ${thrift}/usr $out/packages/Thrift/*/deps/.

    mkdir -p $out/packages/Electron/aRIgh/deps/electron
    electronPath=$(which electron)
    ln -s $electronPath $out/packages/Electron/aRIgh/deps/electron/electron
  '';

  patchEval = ''
    Pkg.build(["Snappy", "CodecZlib", "Thrift"])
  '';
}
