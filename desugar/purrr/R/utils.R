#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

maybe_as_data_frame <- function(out, x) {
    force(out)
    force(x)
  if (is.data.frame(x)) {
    check_tibble()
    tibble::as_tibble(out)
  } else {
    out
  }
}

check_tibble <- function() {
  if (!is_installed("tibble")) {
    abort("The tibble package must be installed")
  }
}

check_tidyselect <- function(){
  if (!is_installed("tidyselect")) {
    abort("Using tidyselect in `map_at()` requires tidyselect")
  }
}

at_selection <- function(nm, .at){
    force(.at)
  if (is_quosures(.at)){
    check_tidyselect()
    .at <- tidyselect::vars_select(.vars = nm, !!!.at)
  }
  .at
}

recycle_args <- function(args) {
    force(args)
  lengths <- map_int(args, length)
  n <- max(lengths)

  stopifnot(all(lengths == 1L | lengths == n))
  to_recycle <- lengths == 1L
  args[to_recycle] <- lapply(args[to_recycle], function(x) rep.int(x, n))
  args
}

names2 <- function(x) {
  names(x) %||% rep("", length(x))
}

#' Infix attribute accessor
#'
#' @description
#'
#' \Sexpr[results=rd, stage=render]{purrr:::lifecycle("soft-deprecated")}
#'
#' Please use the `%@%` operator exported in rlang. It has an
#' interface more consistent with `@`: uses NSE, supports S4 fields,
#' and has an assignment variant.
#'
#' @param x Object
#' @param name Attribute name
#' @export
#' @name get-attr
#' @keywords internal
#' @examples
#' factor(1:3) %@% "levels"
#' mtcars %@% "class"
`%@%` <- function(x, name) {
    force(x)
    force(name)
  signal_soft_deprecated(paste_line(
    "`%@%` is soft-deprecated as of purrr 0.3.0.",
    "Please use the operator provided in rlang instead."
  ))
  attr(x, name, exact = TRUE)
}


#' Generate random sample from a Bernoulli distribution
#'
#' @param n Number of samples
#' @param p Probability of getting `TRUE`
#' @return A logical vector
#' @export
#' @examples
#' rbernoulli(10)
#' rbernoulli(100, 0.1)
rbernoulli <- function(n, p = 0.5) {
    force(n)
    force(p)
  stats::runif(n) > (1 - p)
}

#' Generate random sample from a discrete uniform distribution
#'
#' @param n Number of samples to draw.
#' @param a,b Range of the distribution (inclusive).
#' @export
#' @examples
#' table(rdunif(1e3, 10))
#' table(rdunif(1e3, 10, -5))
rdunif <- function(n, b, a = 1) {
    force(a)
  stopifnot(is.numeric(a), length(a) == 1)
  stopifnot(is.numeric(b), length(b) == 1)

  a1 <- min(a, b)
  b1 <- max(a, b)

  sample(b1 - a1 + 1, n, replace = TRUE) + a1 - 1
}

# magrittr placeholder
globalVariables(".")


has_names <- function(x) {
    force(x)
  nms <- names(x)
  if (is.null(nms)) {
    rep_along(x, FALSE)
  } else {
    !(is.na(nms) | nms == "")
  }
}

ndots <- function(...) nargs()

is_names <- function(nms) {
    force(nms)
  is_character(nms) && !any(is.na(nms) | nms == "")
}

paste_line <- function(...) {
  paste(chr(...), collapse = "\n")
}
cat_line <- function(...) {
  cat(paste0(paste_line(...), "\n"))
}

# From rlang
friendly_type_of <- function(x, length = FALSE) {
    force(x)
    force(length)
  if (is.object(x)) {
    return(sprintf("a `%s` object", paste_classes(x)))
  }

  friendly <- as_friendly_type(typeof(x))

  if (length && is_vector(x)) {
    friendly <- paste0(friendly, sprintf(" of length %s", length(x)))
  }

  friendly
}
as_friendly_type <- function(type) {
    force(type)
  switch(type,
    logical = "a logical vector",
    integer = "an integer vector",
    numeric = ,
    double = "a double vector",
    complex = "a complex vector",
    character = "a character vector",
    raw = "a raw vector",
    string = "a string",
    list = "a list",

    NULL = "NULL",
    environment = "an environment",
    externalptr = "a pointer",
    weakref = "a weak reference",
    S4 = "an S4 object",

    name = ,
    symbol = "a symbol",
    language = "a call",
    pairlist = "a pairlist node",
    expression = "an expression vector",
    quosure = "a quosure",
    formula = "a formula",

    char = "an internal string",
    promise = "an internal promise",
    ... = "an internal dots object",
    any = "an internal `any` object",
    bytecode = "an internal bytecode object",

    primitive = ,
    builtin = ,
    special = "a primitive function",
    closure = "a function",

    type
  )
}
paste_classes <- function(x) {
    force(x)
  paste(class(x), collapse = "/")
}

is_bool <- function(x) {
    force(x)
  is_logical(x, n = 1) && !is.na(x)
}
is_number <- function(x) {
    force(x)
  is_integerish(x, n = 1, finite = TRUE)
}
is_quantity <- function(x) {
    force(x)
  typeof(x) %in% c("integer", "double") && length(x) == 1 && !is.na(x)
}

friendly_type_of_element <- function(x) {
    force(x)
  if (is.object(x)) {
    classes <- paste0("`", paste_classes(x), "`")
    if (single) {
      friendly <- sprintf("a single %s element", classes)
    } else {
      friendly <- sprintf("a %s element", classes)
    }
    return(friendly)
  }

  switch(typeof(x),
    logical   = "a single logical",
    integer   = "a single integer",
    double    = "a single double",
    complex   = "a single complex number",
    character = "a single string",
    raw       = "a single raw value",
    list      = "a list of one element",
    abort("Expected a base vector type")
  )
}


has_crayon <- function() is_installed("crayon") && crayon::has_color()

red       <- function(x) if (has_crayon()) crayon::red(x)       else x
blue      <- function(x) if (has_crayon()) crayon::blue(x)      else x
green     <- function(x) if (has_crayon()) crayon::green(x)     else x
yellow    <- function(x) if (has_crayon()) crayon::yellow(x)    else x
magenta   <- function(x) if (has_crayon()) crayon::magenta(x)   else x
cyan      <- function(x) if (has_crayon()) crayon::cyan(x)      else x
blurred   <- function(x) if (has_crayon()) crayon::blurred(x)   else x
silver    <- function(x) {
    force(x)
 if (has_crayon()) crayon::silver(x)    else x
}
bold      <- function(x) {
    force(x)
 if (has_crayon()) crayon::bold(x)      else x
}
italic    <- function(x) if (has_crayon()) crayon::italic(x)    else x
underline <- function(x) if (has_crayon()) crayon::underline(x) else x

bullet <- function(...) paste0(bold(silver(" * ")), sprintf(...))


quo_invert <- function(call) {
    force(call)
  call <- duplicate(call, shallow = TRUE)

  if (is_quosure(call)) {
    rest <- quo_get_expr(call)
  } else {
    rest <- call
  }
  if (!is_call(rest)) {
    abort("Internal error: Expected call in `quo_invert()`")
  }

  first_quo <- NULL

  # Find first quosured argument. We unwrap constant quosures which
  # add no scoping information.
  while (!is_null(rest)) {
    elt <- node_car(rest)

    if (is_quosure(elt)) {
      if (quo_is_constant(elt)) {
        # Unwrap constant quosures
        node_poke_car(rest, quo_get_expr(elt))
      } else if (is_null(first_quo)) {
        # Record first quosured argument
        first_quo <- elt
        first_node <- rest
      }
    }

    rest <- node_cdr(rest)
  }

  if (is_null(first_quo)) {
    return(call)
  }

  # Take the wrapping quosure env as reference if there is one.
  # Otherwise, take the first quosure detected in arguments.
  if (is_quosure(call)) {
    env <- quo_get_env(call)
    call <- quo_get_expr(call)
  } else {
    env <- quo_get_env(first_quo)
  }

  rest <- first_node
  while (!is_null(rest)) {
    cur <- node_car(rest)

    if (is_quosure(cur) && is_reference(quo_get_env(cur), env)) {
      node_poke_car(rest, quo_get_expr(cur))
    }

    rest <- node_cdr(rest)
  }

  new_quosure(call, env)
}

quo_is_constant <- function(quo) {
    force(quo)
  is_reference(quo_get_env(quo), empty_env())
}
