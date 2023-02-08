library(rastr)
library(fs)
library(purrr)
library(stringr)
library(magrittr)

################################################################################
## signature
################################################################################

sig_new <- function() {
    new.env(parent = emptyenv())
}

sig_add <- function(sig, fun, pos) {
    sig[[fun]] <- pos
}

sig_has <- function(sig, fun) {
    exists(fun, sig, inherits = FALSE)
}

sig_get <- function(sig, fun) {
    sig[[fun]]
}

sig_parse <- function(sigfile) {

    data <-
        sigfile %>%
        read_lines() %>%
        str_trim(side = "both") %>%
        keep(function(str) str != "")

    pattern <- "strict `(.*)` <(.*)>;"
    mat <- str_match(data, pattern)

    sig <- sig_new()

    row_count <- nrow(mat)

    if (row_count == 0) return(sig)

    purrr::walk(1:row_count,
                function(row) {
                    fun <- mat[row, 2]
                    pos <-
                        mat[row, 3] %>%
                        str_split(fixed(",")) %>%
                        pluck(1) %>%
                        map_int(as.integer)

                    if (!any(is.na(pos))) {
                        sig_add(sig, fun, pos)
                    }
                })

    sig
}

sig_print <- function(sig) {
    names <- ls(envir = sig, all.names = TRUE)

    for(name in names) {
        pos <- paste(toString(sig[[name]]), collapse = "\n")
        cat(sprintf("%s: %s\n", name, pos))
    }

    invisible(NULL)
}

sugar <- function(pkg_name, extract_dir, signature_dir, sugar_dir) {
    cat(sprintf("Sugaring %s\n", pkg_name))

    pkg_dir <- path(extract_dir, pkg_name)

    pkg_mod <- path(sugar_dir, pkg_name)
    dir_copy(pkg_dir, pkg_mod, overwrite = FALSE)

    sig <- sig_parse(path(signature_dir, pkg_name))

    sugar_project(pkg_mod, sig)
}

main <- function() {
    args <- commandArgs(trailingOnly=TRUE)

    if (length(args) != 4) {
        stop("Expected four arguments")
    }

    pkg_name <- args[1]
    extract_dir <- path_expand(args[2])
    signature_dir <- path_expand(args[3])
    sugar_dir <- path_expand(args[4])

    sugar(pkg_name, extract_dir, signature_dir, sugar_dir)
}


main()
