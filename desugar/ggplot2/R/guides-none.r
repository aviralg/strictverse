
#' Empty guide
#'
#' This guide draws nothing.
#'
#' @inheritParams guide_axis
#'
#' @export
#'
guide_none <- function(title = waiver(), position = waiver()) {
    force(title)
    force(position)
  structure(
    list(
      title = title,
      position = position,
      available_aes = "any"
    ),
    class = c("guide", "guide_none")
  )
}

#' @export
guide_train.guide_none <- function(guide, scale, aesthetic = NULL) {
    force(guide)
  guide
}

#' @export
guide_merge.guide_none <- function(guide, new_guide) {
  new_guide
}

#' @export
guide_geom.guide_none <- function(guide, layers, default_mapping) {
    force(guide)
  guide
}

#' @export
guide_transform.guide_none <- function(guide, coord, panel_params) {
    force(guide)
  guide
}

#' @export
guide_gengrob.guide_none <- function(guide, theme, ...) {
    force(guide)
  zeroGrob()
}
