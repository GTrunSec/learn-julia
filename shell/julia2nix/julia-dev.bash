JULIA_MASTER="/home/$USER/ghq/git.sr.ht/~ninjin/julia-nix/"
case "$1" in
    "link")
        shift 1

        if [[ -x "$JULIA_MASTER/julia" ]]; then
            ln -sf $JULIA_MASTER/julia $PRJ_ROOT/julia
        fi
        ;;
    "build")
        cd $JULIA_MASTER
        nix-shell --pure --run make
        ;;
    "clone")
        git clone https://github.com/JuliaLang/julia.git /home/$USER/ghq/git.sr.ht/~ninjin/julia-nix
        cd $JULIA_MASTER && git apply $PRJ_ROOT/shell/julia2nix/julia-nix.patch
        ;;
    "test")
        echo $PRJ_ROOT
        ;;
esac
