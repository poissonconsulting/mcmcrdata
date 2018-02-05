#' Slice mcmcr data
#'
#' @inheritParams dplyr::slice_
#' @param .data An mcmcr_data object
#' @export
slice_.mcmcr_data <- function(.data, ..., .dots){
  check_missing_colnames(.data$data, "IDX")
  data <- .data$data

  data$IDX <- 1:nrow(data)
  data <- dplyr::slice_(data, ..., .dots = .dots)
  .data$mcmcr[[1]] <- filter_mcmcarray(.data$mcmcr[[1]], data$IDX)
  data$IDX <- NULL
  .data$data <- data
  .data
}
