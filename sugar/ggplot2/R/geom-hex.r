#' Hexagonal heatmap of 2d bin counts
#'
#' Divides the plane into regular hexagons, counts the number of cases in
#' each hexagon, and then (by default) maps the number of cases to the hexagon
#' fill.  Hexagon bins avoid the visual artefacts sometimes generated by
#' the very regular alignment of [geom_bin2d()].
#'
#' @eval rd_aesthetics("geom", "hex")
#' @seealso [stat_bin2d()] for rectangular binning
#' @param geom,stat Override the default connection between `geom_hex()` and
#'   `stat_binhex()`.
#' @export
#' @inheritParams layer
#' @inheritParams geom_point
#' @export
#' @examples
#' d <- ggplot(diamonds, aes(carat, price))
#' d + geom_hex()
#'
#' \donttest{
#' # You can control the size of the bins by specifying the number of
#' # bins in each direction:
#' d + geom_hex(bins = 10)
#' d + geom_hex(bins = 30)
#'
#' # Or by specifying the width of the bins
#' d + geom_hex(binwidth = c(1, 1000))
#' d + geom_hex(binwidth = c(.1, 500))
#' }
geom_hex <- function(mapping = NULL, data = NULL,
                     stat = "binhex", position = "identity",
                     ...,
                     na.rm = FALSE,
                     show.legend = NA,
                     inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomHex,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}


#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHex <- ggproto("GeomHex", Geom,
  draw_group = function(data, panel_params, coord) {
    if (!inherits(coord, "CoordCartesian")) {
      abort("geom_hex() only works with Cartesian coordinates")
    }

    coords <- coord$transform(data, panel_params)
    ggname("geom_hex", hexGrob(
      coords$x, coords$y,
      gp = gpar(
        col = coords$colour,
        fill = alpha(coords$fill, coords$alpha),
        lwd = coords$size * .pt,
        lty = coords$linetype
      )
    ))
  },

  required_aes = c("x", "y"),

  default_aes = aes(
    colour = NA,
    fill = "grey50",
    size = 0.5,
    linetype = 1,
    alpha = NA
  ),

  draw_key = draw_key_polygon
)


# Draw hexagon grob
# Modified from code by Nicholas Lewin-Koh and Martin Maechler
#
# @param x positions of hex centres
# @param y positions
# @param size vector of hex sizes
# @param gp graphical parameters
# @keyword internal
hexGrob <- function(x, y, size = rep(1, length(x)), gp = gpar()) {
  if (length(y) != length(x)) abort("`x` and `y` must have the same length")

  dx <- resolution(x, FALSE)
  dy <- resolution(y, FALSE) / sqrt(3) / 2 * 1.15

  hexC <- hexbin::hexcoords(dx, dy, n = 1)

  n <- length(x)

  polygonGrob(
    x = rep.int(hexC$x, n) * rep(size, each = 6) + rep(x, each = 6),
    y = rep.int(hexC$y, n) * rep(size, each = 6) + rep(y, each = 6),
    default.units = "native",
    id.lengths = rep(6, n), gp = gp
  )
}