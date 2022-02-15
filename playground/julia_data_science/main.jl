using Pkg

function has_manifest_file()
    return isfile(joinpath(pwd(),"Manifest.toml")) || isfile(joinpath(pwd(),"JuliaManifest.toml"))
end


