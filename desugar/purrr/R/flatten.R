#' Flatten a list of lists into a simple vector.
#'
#' These functions remove a level hierarchy from a list. They are similar to
#' [unlist()], but they only ever remove a single layer of hierarchy and they
#' are type-stable, so you always know what the type of the output is.
#'
#' @param .x A list to flatten. The contents of the list can be anything for
#'   `flatten()` (as a list is returned), but the contents must match the
#'   type for the other functions.
#' @return `flatten()` returns a list, `flatten_lgl()` a logical
#'   vector, `flatten_int()` an integer vector, `flatten_dbl()` a
#'   double vector, and `flatten_chr()` a character vector.
#'
#'   `flatten_dfr()` and `flatten_dfc()` return data frames created by
#'   row-binding and column-binding respectively. They require dplyr to
#'   be installed.
#' @inheritParams map
#' @export
#' @examples
#' x <- rerun(2, sample(4))
#' x
#' x %>% flatten()
#' x %>% flatten_int()
#'
#' # You can use flatten in conjunction with map
#' x %>% map(1L) %>% flatten_int()
#' # But it's more efficient to use the typed map instead.
#' x %>% map_int(1L)
flatten <- function(.x) {
    force(.x)
  .Call(flatten_impl, .x)
}

#' @export
#' @rdname flatten
flatten_lgl <- function(.x) {
    force(.x)
  .Call(vflatten_impl, .x, "logical")
}

#' @export
#' @rdname flatten
flatten_int <- function(.x) {
    force(.x)
  .Call(vflatten_impl, .x, "integer")
}

#' @export
#' @rdname flatten
flatten_dbl <- function(.x) {
    force(.x)
  .Call(vflatten_impl, .x, "double")
}

#' @export
#' @rdname flatten
flatten_chr <- function(.x) {
    force(.x)
  .Call(vflatten_impl, .x, "character")
}

#' @export
#' @rdname flatten
flatten_raw <- function(.x) {
    force(.x)
  .Call(vflatten_impl, .x, "raw")
}

#' @export
#' @rdname flatten
flatten_dfr <- function(.x, .id = NULL) {
    force(.x)
  if (!is_installed("dplyr")) {
    abort("`flatten_dfr()` requires dplyr")
  }

  res <- .Call(flatten_impl, .x)
  dplyr::bind_rows(res, .id = .id)
}

#' @export
#' @rdname flatten
flatten_dfc <- function(.x) {
    force(.x)
  if (!is_installed("dplyr")) {
    abort("`flatten_dfc()` requires dplyr")
  }

  res <- .Call(flatten_impl, .x)
  dplyr::bind_cols(res)
}

#' @export
#' @rdname flatten
#' @usage NULL
flatten_df <- flatten_dfr
