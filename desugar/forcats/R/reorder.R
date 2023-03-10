#' Reorder factor levels by sorting along another variable
#'
#' `fct_reorder()` is useful for 1d displays where the factor is mapped to
#' position; `fct_reorder2()` for 2d displays where the factor is mapped to
#' a non-position aesthetic. `last2()` and `first2()` are helpers for `fct_reorder2()`;
#' `last2()` finds the last value of `y` when sorted by `x`; `first2()` finds the first value.
#'
#' @param .f A factor (or character vector).
#' @param .x,.y The levels of `f` are reordered so that the values
#'    of `.fun(.x)` (for `fct_reorder()`) and `fun(.x, .y)` (for `fct_reorder2()`)
#'    are in ascending order.
#' @param .fun n summary function. It should take one vector for
#'   `fct_reorder`, and two vectors for `fct_reorder2`, and return a single
#'   value.
#' @param ... Other arguments passed on to `.fun`. A common argument is
#'   `na.rm = TRUE`.
#' @param .desc Order in descending order? Note the default is different
#'   between `fct_reorder` and `fct_reorder2`, in order to
#'   match the default ordering of factors in the legend.
#' @importFrom stats median
#' @export
#' @examples
#' df <- tibble::tribble(
#'   ~color,     ~a, ~b,
#'   "blue",      1,  2,
#'   "green",     6,  2,
#'   "purple",    3,  3,
#'   "red",       2,  3,
#'   "yellow",    5,  1
#' )
#' df$color <- factor(df$color)
#' fct_reorder(df$color, df$a, min)
#' fct_reorder2(df$color, df$a, df$b)
#'
#' boxplot(Sepal.Width ~ Species, data = iris)
#' boxplot(Sepal.Width ~ fct_reorder(Species, Sepal.Width), data = iris)
#' boxplot(Sepal.Width ~ fct_reorder(Species, Sepal.Width, .desc = TRUE), data = iris)
#'
#' chks <- subset(ChickWeight, as.integer(Chick) < 10)
#' chks <- transform(chks, Chick = fct_shuffle(Chick))
#'
#' if (require("ggplot2")) {
#' ggplot(chks, aes(Time, weight, colour = Chick)) +
#'   geom_point() +
#'   geom_line()
#'
#' # Note that lines match order in legend
#' ggplot(chks, aes(Time, weight, colour = fct_reorder2(Chick, Time, weight))) +
#'   geom_point() +
#'   geom_line() +
#'   labs(colour = "Chick")
#' }
fct_reorder <- function(.f, .x, .fun = median, ..., .desc = FALSE) {
    force(.f)
    force(.x)
    force(.fun)
  f <- check_factor(.f)
  stopifnot(length(f) == length(.x))
  ellipsis::check_dots_used()

  summary <- tapply(.x, .f, .fun, ...)
  # This is a bit of a weak test, but should detect the most common case
  # where `.fun` returns multiple values.
  if (is.list(summary)) {
    stop("`fun` must return a single value per group", call. = FALSE)
  }

  lvls_reorder(f, order(summary, decreasing = .desc))
}

#' @export
#' @rdname fct_reorder
fct_reorder2 <- function(.f, .x, .y, .fun = last2, ..., .desc = TRUE) {
    force(.f)
    force(.x)
    force(.y)
    force(.fun)
  f <- check_factor(.f)
  stopifnot(length(f) == length(.x), length(.x) == length(.y))
  ellipsis::check_dots_used()

  summary <- tapply(seq_along(.x), f, function(i) .fun(.x[i], .y[i], ...))
  if (is.list(summary)) {
    stop("`fun` must return a single value per group", call. = FALSE)
  }

  lvls_reorder(.f, order(summary, decreasing = .desc))
}


#' @export
#' @rdname fct_reorder
last2 <- function(.x, .y) {
    force(.x)
    force(.y)
  .y[order(.x, na.last = FALSE)][length(.y)]
}

#' @export
#' @rdname fct_reorder
first2 <- function(.x, .y) {
  .y[order(.x)][1]
}



#' Reorder factor levels by first appearance, frequency, or numeric order
#'
#' This family of functions changes only the order of the levels.
#' * `fct_inorder()`: by the order in which they first appear.
#' * `fct_infreq()`: by number of observations with each level (largest first)
#' * `fct_inseq()`: by numeric value of level.
#'
#' @inheritParams lvls_reorder
#' @param f A factor
#' @export
#' @examples
#' f <- factor(c("b", "b", "a", "c", "c", "c"))
#' f
#' fct_inorder(f)
#' fct_infreq(f)
#'
#' f <- factor(1:3, levels = c("3", "2", "1"))
#' f
#' fct_inseq(f)
fct_inorder <- function(f, ordered = NA) {
    force(f)
    force(ordered)
  f <- check_factor(f)

  idx <- as.integer(f)[!duplicated(f)]
  idx <- idx[!is.na(idx)]
  lvls_reorder(f, idx, ordered = ordered)
}

#' @export
#' @rdname fct_inorder
fct_infreq <- function(f, ordered = NA) {
    force(f)
    force(ordered)
  f <- check_factor(f)

  lvls_reorder(f, order(table(f), decreasing = TRUE), ordered = ordered)
}

#' @export
#' @rdname fct_inorder
fct_inseq <- function(f, ordered = NA) {
    force(f)
  f <- check_factor(f)

  num_levels <- suppressWarnings(as.numeric(levels(f)))

  if (all(is.na(num_levels))) {
    stop("At least one existing level must be coercible to numeric.", call. = FALSE)
  }

  lvls_reorder(f, order(num_levels), ordered = ordered)
}

