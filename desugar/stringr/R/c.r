#' Join multiple strings into a single string.
#'
#' Joins two or more vectors element-wise into a single character vector,
#' optionally inserting `sep` between input vectors. If `collapse` is not `NULL`,
#' it will be inserted between elements of the result, returning a character
#' vector of length 1.
#'
#' To understand how `str_c` works, you need to imagine that you are building up
#' a matrix of strings. Each input argument forms a column, and is expanded to
#' the length of the longest argument, using the usual recyling rules.  The
#' `sep` string is inserted between each column. If collapse is `NULL` each row
#' is collapsed into a single string. If non-`NULL` that string is inserted at
#' the end of each row, and the entire matrix collapsed to a single string.
#'
#' @param ... One or more character vectors. Zero length arguments
#'   are removed. Short arguments are recycled to the length of the
#'   longest.
#'
#'   Like most other R functions, missing values are "infectious": whenever
#'   a missing value is combined with another string the result will always
#'   be missing. Use [str_replace_na()] to convert `NA` to
#'   `"NA"`
#' @param sep String to insert between input vectors.
#' @param collapse Optional string used to combine input vectors into single
#'   string.
#' @return If `collapse = NULL` (the default) a character vector with
#'   length equal to the longest input string. If `collapse` is
#'   non-NULL, a character vector of length 1.
#' @seealso [paste()] for equivalent base R functionality, and
#'    [stringi::stri_join()] which this function wraps
#' @export str_c
#' @examples
#' str_c("Letter: ", letters)
#' str_c("Letter", letters, sep = ": ")
#' str_c(letters, " is for", "...")
#' str_c(letters[-26], " comes before ", letters[-1])
#'
#' str_c(letters, collapse = "")
#' str_c(letters, collapse = ", ")
#'
#' # Missing inputs give missing outputs
#' str_c(c("a", NA, "b"), "-d")
#' # Use str_replace_NA to display literal NAs:
#' str_c(str_replace_na(c("a", NA, "b")), "-d")
#' @import stringi
str_c <- function(..., sep = "", collapse = NULL) {
    force(sep)
    force(collapse)
  stri_c(..., sep = sep, collapse = collapse, ignore_null = TRUE)
}
