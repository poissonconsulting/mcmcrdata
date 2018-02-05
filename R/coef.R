#' Coef mcmcr data
#'
#' Coefficients for an mcmcr_data object.
#'
#' @param object The mcmcr_data object.
#' @param conf_level A number specifying the confidence level. By default 0.95.
#' @param ... Not used.
#' @return A tidy tibble of the coefficient terms.
#' @export
coef.mcmcr_data <- function(object, conf_level = 0.95, ...) {
  coef <- coef(object$mcmcr, conf_level = conf_level, ...)
  dplyr::bind_cols(object$data, coef)
}
