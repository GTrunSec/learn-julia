{ pkgs, lib, budUtils, inputs, ... }: {
  bud.cmds = with pkgs; {
    dev = {
      writer = budUtils.writeBashWithPaths [ coreutils nixUnstable git ];
      synopsis = "julia2nix";
      help = "link julia from dev branch";
      script = ./julia-dev.bash;
      extraScript = ''
      '';
    };
  };
}
