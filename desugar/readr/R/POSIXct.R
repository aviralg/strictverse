POSIXct <- function(x, tz = "UTC") {
    force(x)
    force(tz)
  structure(x, class = c("POSIXct", "POSIXt"), tzone = tz)
}
