{ pkgs, lib, budUtils, inputs, ... }: {
  bud.cmds = with pkgs; {
    dev = {
      writer = budUtils.writeBashWithPaths [ coreutils nixUnstable git ];
      synopsis = "dev";
      help = "link julia from dev branch";
      script = ./julia-dev.bash;
      extraScript = ''
      '';
    };
  };
}
