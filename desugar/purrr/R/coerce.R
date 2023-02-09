# Used internally by map and flatten.
# Exposed here for testing
coerce <- function(x, type) {
    force(x)
    force(type)
  .Call(coerce_impl, x, type)
}

coerce_lgl <- function(x) {
    force(x)
 coerce(x, "logical")
}
coerce_int <- function(x) {
    force(x)
 coerce(x, "integer")
}
coerce_dbl <- function(x) {
    force(x)
 coerce(x, "double")
}
coerce_chr <- function(x) {
    force(x)
 coerce(x, "character")
}
coerce_raw <- function(x) {
    force(x)
 coerce(x, "raw")
}
