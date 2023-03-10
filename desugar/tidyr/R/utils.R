#' Pipe operator
#'
#' See \code{\link[magrittr]{%>%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

# https://github.com/r-lib/vctrs/issues/211
reconstruct_tibble <- function(input, output, ungrouped_vars = character()) {
    force(input)
    force(output)
  if (inherits(input, "grouped_df")) {
    old_groups <- dplyr::group_vars(input)
    new_groups <- intersect(setdiff(old_groups, ungrouped_vars), names(output))
    dplyr::grouped_df(output, new_groups, drop = dplyr::group_by_drop_default(input))
  } else if (inherits(input, "tbl_df")) {
    # Assume name repair carried out elsewhere
    as_tibble(output, .name_repair = "minimal")
  } else {
    output
  }
}


imap <- function(.x, .f, ...) {
    force(.x)
    force(.f)
  map2(.x, names(.x) %||% character(0), .f, ...)
}

seq_nrow <- function(x) {
    force(x)
 seq_len(nrow(x))
}
seq_ncol <- function(x) seq_len(ncol(x))

# Until https://github.com/r-lib/rlang/issues/675 is fixed
ensym2 <- function(arg) {
  arg <- ensym(arg)

  expr <- eval_bare(expr(enquo(!!arg)), caller_env())
  expr <- quo_get_expr(expr)

  if (is_string(expr)) {
    sym(expr)
  } else if (is_symbol(expr)) {
    expr
  } else {
    abort("Must supply a symbol or a string as argument")
  }
}

last <- function(x) x[[length(x)]]


#' Legacy name repair
#'
#' Ensures all column names are unique using the approach found in
#' tidyr 0.8.3 and earlier. Only use this function if you want to preserve
#' the naming strategy, otherwise you're better off adopting the new
#' tidyverse standard with `name_repair = "universal"`
#'
#' @param nm Character vector of names
#' @param prefix prefix Prefix to use for unnamed column
#' @param sep Separator to use between name and unique suffix
#' @keywords internal
#' @export
#' @examples
#' df <- tibble(x = 1:2, y = list(tibble(x = 3:5), tibble(x = 4:7)))
#'
#' # Doesn't work because it would produce a data frame with two
#' # columns called x
#' \dontrun{unnest(df, y)}
#'
#' # The new tidyverse standard:
#' unnest(df, y, names_repair = "universal")
#'
#' # The old tidyr approach
#' unnest(df, y, names_repair = tidyr_legacy)
tidyr_legacy <- function(nms, prefix = "V", sep = "") {
    force(nms)
  if (length(nms) == 0) return(character())
  blank <- nms == ""
  nms[!blank] <- make.unique(nms[!blank], sep = sep)
  new_nms <- setdiff(paste(prefix, seq_along(nms), sep = sep), nms)
  nms[blank] <- new_nms[seq_len(sum(blank))]
  nms
}


# Work around bug in base R where data[x] <- data[x] turns a 0-col data frame-col
# into a list of NULLs
update_cols <- function(old, new) {
    force(old)
    force(new)
  for (col in names(new)) {
    old[[col]] <- new[[col]]
  }
  old
}

# Own copy since it might disappear from vctrs since it
# isn't well thought out
vec_repeat <- function(x, each = 1L, times = 1L) {
    force(x)
  vec_assert(each, size = 1L)
  vec_assert(times, size = 1L)

  idx <- rep(vec_seq_along(x), times = times, each = each)
  vec_slice(x, idx)
}

check_present <- function(x) {
  arg <- ensym(x)
  if (missing(x)) {
    abort(paste0("Argument `", arg, "` is missing with no default"))
  }

}
