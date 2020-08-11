using Documenter, ToggledLH

makedocs(
    modules = [ToggledLH],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "hendri54",
    sitename = "ToggledLH.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/hendri54/ToggledLH.jl.git",
    push_preview = true
)
