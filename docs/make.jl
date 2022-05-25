using Documenter

makedocs(
    clean=true,
    sitename = "EDIAM",
    format = Documenter.HTML(prettyurls = false),
    pages = Any[
         "EDIAM ajustado a macro-regiones" => "index.md",
         "Datos" => Any[
           "datos/cmip_data.md"
         ]
    
])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/milocortes/prueba-documenter.git"
)
