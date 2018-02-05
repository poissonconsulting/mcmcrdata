#' Is an mcmcr data object
#'
#' Tests whether x is an object of class 'mcmcr_data'
#'
#' @param x The object to test.
#'
#' @return A flag indicating whether the test was positive.
#' @export
is.mcmcr_data <- function(x) {
  inherits(x, "mcmcr_data")
}
