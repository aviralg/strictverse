#' Read lines from a file or string by chunk.
#'
#' @inheritParams datasource
#' @inheritParams read_delim_chunked
#' @keywords internal
#' @family chunked
#' @export
read_lines_chunked <- function(file, callback, chunk_size = 10000, skip = 0,
  locale = default_locale(), na = character(), progress = show_progress()) {
    force(file)
    force(callback)
    force(chunk_size)
    force(skip)
    force(na)
    force(progress)
  if (empty_file(file)) {
    return(character())
  }
  ds <- datasource(file, skip = skip, skip_empty_rows = FALSE)
  callback <- as_chunk_callback(callback)
  on.exit(callback$finally(), add = TRUE)

  read_lines_chunked_(ds, locale, na, chunk_size, callback, FALSE, progress)

  return(callback$result())
}


#' @export
#' @rdname read_lines_chunked
read_lines_raw_chunked <- function(file, callback, chunk_size = 10000, skip = 0,
                                   progress = show_progress()) {
    force(file)
    force(callback)
    force(chunk_size)
    force(skip)
    force(progress)
  if (empty_file(file)) {
    return(character())
  }
  ds <- datasource(file, skip = skip, skip_empty_rows = FALSE)
  callback <- as_chunk_callback(callback)
  on.exit(callback$finally(), add = TRUE)

  read_lines_raw_chunked_(ds, chunk_size, callback, progress)

  return(callback$result())
}
