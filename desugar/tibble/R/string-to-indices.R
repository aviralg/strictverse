string_to_indices <- function(x) {
    force(x)
  .Call(`tibble_string_to_indices`, as.character(x))
}
