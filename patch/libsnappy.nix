{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  src = fetchurl {
    url = "https://github.com/davidanthoff/SnappyBuilder/releases/download/v1.1.7%2Bbuild.2/Snappy.x86_64-linux-gnu.tar.gz";
    sha256 = "sha256-4xvDcStCDLG5kdCFeXP0U9IAR5k5UhRvjvl4qank0sg=";
  };

in
runCommand "libsnappy-1.7.0"
{
  inherit src;
} ''
  mkdir -p $out/
  tar -xf $src .
  cp -r *  $out
''
