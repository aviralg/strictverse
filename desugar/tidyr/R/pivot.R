check_spec <- function(spec) {
    force(spec)
  # Eventually should just be vec_assert() on partial_frame()
  # Waiting for https://github.com/r-lib/vctrs/issues/198

  if (!is.data.frame(spec)) {
    stop("`spec` must be a data frame", call. = FALSE)
  }

  if (!has_name(spec, ".name") || !has_name(spec, ".value")) {
    stop("`spec` must have `.name` and `.value` columns", call. = FALSE)
  }

  # Ensure .name and .value come first
  vars <- union(c(".name", ".value"), names(spec))
  spec[vars]
}

wrap_error_names <- function(code) {
    force(code)
  tryCatch(
    code,
    vctrs_error_names = function(cnd) {
      abort(
        c(
          "Failed to create output due to bad names.",
          "Choose another strategy with `names_repair`"
        ),
        parent = cnd
      )
    }
  )
}
