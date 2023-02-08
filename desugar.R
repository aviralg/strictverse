library(rastr)
library(fs)
library(purrr)
library(stringr)
library(magrittr)

desugar <- function(pkg_name, sugar_dir, desugar_dir) {
    cat(sprintf("Desugaring %s\n", pkg_name))

    pkg_dir <- path(sugar_dir, pkg_name)

    pkg_desug <- path(desugar_dir, pkg_name)

    dir_copy(pkg_dir, pkg_desug, overwrite = FALSE)

    desugar_project(pkg_desug)
}

main <- function() {
    args <- commandArgs(trailingOnly=TRUE)

    if (length(args) != 3) {
        stop("Expected three arguments")
    }

    pkg_name <- args[1]
    sugar_dir <- path_expand(args[2])
    desugar_dir <- path_expand(args[3])


    desugar(pkg_name, sugar_dir, desugar_dir)
}


main()
