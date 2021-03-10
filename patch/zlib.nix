{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  src = fetchTarball {
    url = "https://zlib.net/zlib-1.2.11.tar.gz";
    sha256 = "sha256:098k1dq86ix9r5z63s1snxkmqz0mhdd1jy7inf5djwd3vv5jh0h1";
  };

in
runCommand "zlib" { inherit src; } ''
  mkdir -p $out
  cp -r $src/. $out
''
