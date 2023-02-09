#' @export
tbl.DBIConnection <- function(src, from, ...) {
    force(src)
    force(from)
  check_dbplyr()
  tbl(dbplyr::src_dbi(src, auto_disconnect = FALSE), from = from, ...)
}

#' @export
copy_to.DBIConnection <- function(dest, df, name = deparse(substitute(df)),
                                  overwrite = FALSE, ...) {
    force(dest)
    force(overwrite)
  check_dbplyr()
  copy_to(
    dbplyr::src_dbi(dest, auto_disconnect = FALSE),
    df = df,
    name = name,
    overwrite = overwrite,
    ...
  )
}
