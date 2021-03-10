{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  src = fetchurl {
    url = "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/Zlib.v1.2.11.x86_64-linux-gnu.tar.gz";
    sha256 = "sha256-HDschSBxP5jT9gXuHKXi42Vtkt22RBq+7v8K4SoRpiA=";
  };

in
runCommand "zlib" { inherit src; } ''
  mkdir -p $out/usr/downloads
  cp -r $src $out/usr/downloads/Zlib.v1.2.11.x86_64-linux-gnu.tar.gz
''
