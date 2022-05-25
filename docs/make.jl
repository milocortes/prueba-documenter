using Documenter

makedocs(
    sitename = "Example",
    format = Documenter.HTML()
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/milocortes/prueba-documenter.git"
)
