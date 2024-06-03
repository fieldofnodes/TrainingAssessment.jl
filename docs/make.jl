using TrainingAssessment
using Documenter

DocMeta.setdocmeta!(TrainingAssessment, :DocTestSetup, :(using TrainingAssessment); recursive=true)

makedocs(;
    modules=[TrainingAssessment],
    authors="Jonathan Miller jonathan.miller@fieldofnodes.com",
    sitename="TrainingAssessment.jl",
    format=Documenter.HTML(;
        canonical="https://fieldofnodes.github.io/TrainingAssessment.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/fieldofnodes/TrainingAssessment.jl",
    devbranch="main",
)
