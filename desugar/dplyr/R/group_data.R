#' Grouping metadata
#'
#' @description
#' * `group_data()` returns a data frame that defines the grouping structure.
#'   The columns give the values of the grouping variables. The last column,
#'   always called `.rows`, is a list of integer vectors that gives the
#'   location of the rows in each group. You can retrieve just the grouping
#'   data with `group_keys()`, and just the locations with `group_rows()`.
#'
#' * `group_indices()` returns an integer vector the same length as `.data`
#'   that gives the group that each row belongs to (cf. `group_rows()` which
#'   returns the rows which each group contains). `group_indices()` with no
#'   argument is deprecated, superseded by [cur_group_id()].
#'
#' * `group_vars()` gives names of grouping variables as character vector;
#'   `groups()` gives the names as a list of symbols.
#'
#' * `group_size()` gives the size of each group, and `n_groups()` gives the
#'   total number of groups.
#'
#' See [context] for equivalent functions that return values for the _current_
#' group.
#' @param .data,.tbl,x A data frame or extension (like a tibble or grouped
#'   tibble).
#' @param ... Use of `...` is now deprecated; please use `group_by()` first
#'   instead.
#' @keywords internal
#' @examples
#' df <- tibble(x = c(1,1,2,2))
#' group_vars(df)
#' group_rows(df)
#' group_data(df)
#' group_indices(df)
#'
#' gf <- group_by(df, x)
#' group_vars(gf)
#' group_rows(gf)
#' group_data(gf)
#' group_indices(gf)
#' @export
group_data <- function(.data) {
  UseMethod("group_data")
}

#' @export
group_data.data.frame <- function(.data) {
    force(.data)
  rows <- new_list_of(list(seq_len(nrow(.data))), ptype = integer())
  new_data_frame(list(.rows = rows), n = 1L)
}

#' @export
group_data.tbl_df <- function(.data) {
    force(.data)
  as_tibble(NextMethod())
}

#' @export
group_data.rowwise_df <- function(.data) {
    force(.data)
  attr(.data, "groups")
}

#' @export
group_data.grouped_df <- function(.data) {
    force(.data)
  attr(validate_grouped_df(.data), "groups")
}

# -------------------------------------------------------------------------

#' @rdname group_data
#' @export
group_keys <- function(.tbl, ...) {
  UseMethod("group_keys")
}
#' @export
group_keys.data.frame <- function(.tbl, ...) {
    force(.tbl)
  if (dots_n(...) > 0) {
    lifecycle::deprecate_warn(
      "1.0.0", "group_keys(... = )",
      details = "Please `group_by()` first"
    )
    .tbl <- group_by(.tbl, ...)
  }
  out <- group_data(.tbl)
  .Call(`dplyr_group_keys`, out)
}
#' @rdname group_data
#' @export
group_rows <- function(.data) {
  group_data(.data)[[".rows"]]
}

#' @export
#' @rdname group_data
group_indices <- function(.data, ...) {
  if (nargs() == 0) {
    lifecycle::deprecate_warn("1.0.0", "group_indices()", "cur_group_id()")
    return(cur_group_id())
  }

  UseMethod("group_indices")
}
#' @export
group_indices.data.frame <- function(.data, ...) {
    force(.data)
  if (dots_n(...) > 0) {
    lifecycle::deprecate_warn(
      "1.0.0", "group_keys(... = )",
      details = "Please `group_by()` first"
    )
    .data <- group_by(.data, ...)
  }

  .Call(`dplyr_group_indices`, .data, group_rows(.data))
}

#' @export
#' @rdname group_data
group_vars <- function(x) {
  UseMethod("group_vars")
}
#' @export
group_vars.data.frame <- function(x) {
    force(x)
  setdiff(names(group_data(x)), ".rows")
}

#' @export
#' @rdname group_data
groups <- function(x) {
    force(x)
  UseMethod("groups")
}
#' @export
groups.data.frame <- function(x) {
    force(x)
  syms(group_vars(x))
}

#' @export
#' @rdname group_data
group_size <- function(x) UseMethod("group_size")
#' @export
group_size.data.frame <- function(x) {
    force(x)
  lengths(group_rows(x))
}

#' @export
#' @rdname group_data
n_groups <- function(x) {
    force(x)
 UseMethod("n_groups")
}
#' @export
n_groups.data.frame <- function(x) {
    force(x)
  nrow(group_data(x))
}
