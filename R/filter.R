filter_mcmcarray <- function(x, idx) {
  stopifnot(is.mcmcarray(x))
  stopifnot(ndims(x) == 3)

  x <- x[,,idx,drop = FALSE]
  class(x) <- "mcmcarray"
  x
}

#' Filter mcmcr data
#'
#' @inheritParams dplyr::filter_
#' @param .data An mcmcr_data object
#' @export
filter_.mcmcr_data <- function(.data, ..., .dots){
  check_missing_colnames(.data$data, "IDX")
  data <- .data$data

  data$IDX <- 1:nrow(data)
  data <- dplyr::filter_(data, ..., .dots = .dots)
  .data$mcmcr[[1]] <- filter_mcmcarray(.data$mcmcr[[1]], data$IDX)
  data$IDX <- NULL
  .data$data <- data
  .data
}
