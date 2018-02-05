#' @export
as.mcmcr.mcmcr_data <- function(x, ...) {
  x$mcmcr
}

#' @export
as.data.frame.mcmcr_data <- function(x, ...) {
  x$data
}
