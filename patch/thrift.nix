{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  src = fetchurl {
    url = "https://github.com/tanmaykm/JuliaThriftBuilder/releases/download/julia1.0-thrift0.11.0/JuliaThriftBuilder.v0.2.0.x86_64-linux-gnu.tar.gz";
    sha256 = "sha256-pXqxEZ4N+iiigx4/d5xdPMNKZdgZ46ax8dBmK9NNTaU=";
  };

in
runCommand "thrift" { inherit src; } ''
  mkdir -p $out
  tar -xf $src .
  cp -r * $out
''
