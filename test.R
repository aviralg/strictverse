install.packages("decor")

library(fs)

test_package <- function(dir) {
    reporter <- testthat::ListReporter$new()

    testthat::test_local(path = dir,
                         reporter = reporter,
                         stop_on_failure = FALSE,
                         stop_on_warning = FALSE)

    reporter$get_results()
}

test_result_to_df <- function(results) {

    check_null <- function(val) if (is.null(val)) NA_character_ else val

    dfs <- Map(function(result) {
        file <- result$file
        context <- result$context

        index <- 0

        dfs <- Map(
            function(result) {
                message <- result$message

                ##  c(first_line, first_byte, last_line, last_byte, first_column, last_column, first_parsed, last_parsed)
                                        #srcref <- paste(toString(unclass(result$srcref)), collapse = ",")
                                        #first_line <- result$srcref[1]
                                        #first_byte <- result$srcref[2]
                                        #last_line <- result$srcref[3]
                                        #last_byte <- result$srcref[4]
                                        #first_column <- result$srcref[5]
                                        #last_column <- result$srcref[6]
                                        #first_parsed <- result$srcref[7]
                                        #last_parsed <- result$srcref[8]

                test <- result$test
                class <- paste(class(result), collapse = ",")

                index <<- index + 1

                data.frame(file = check_null(file),
                           context = check_null(context),
                           index = index
                           message = check_null(message),
                                        #srcref = srcref,
                                        #first_line = first_line,
                                        #first_byte = first_byte,
                                        #last_line = last_line,
                                        #last_byte = last_byte,
                                        #first_column = first_column,
                                        #last_column = last_column,
                                        #first_parsed = first_parsed,
                                        #last_parsed = last_parsed,
                           test = check_null(test),
                           class = check_null(class))
            },
            result$results)

        rbind(dfs)
    },
    results)

    rbind(dfs)
}

test <- function(pkg_dir, res_file) {
    res <- test_package(pkg_dir)
    df <- test_result_to_df(res)
    fst::write_fst(df, res_file)
}

main <- function() {
    args <- commandArgs(trailingOnly=TRUE)

    print(args)

    if (length(args) != 4) {
        stop("Expected four arguments")
    }

    src_dir <- path_expand(args[1])
    res_dir <- path_expand(args[2])
    pkg_name <- args[3]
    res_filename <- args[4]

    pkg_dir <- path(src_dir, pkg_name)
    res_file <- path(res_dir, pkg_name, res_filename)

    dir_create(path_dir(res_file))

    test(pkg_dir, res_file)
}

main()
