combine_values_mcmcr_data <- function(x, fun, by, suffix) {
  if (!all(vapply(x, is.mcmcr_data, TRUE))) error("objects in x must be of class mcmcr_data")

  lapply(x, check_mcmcr_data)

  data <- lapply(x, as.data.frame)

  for (i in seq_along(data)) {
    data[[i]][paste0("..ID", i)] <- 1:nrow(data[[i]])
  }
  data <- purrr::reduce(data, dplyr::inner_join, by = by, suffix = suffix)

  mcmcr <- lapply(x, as.mcmcr)

  names <- vapply(mcmcr, names, "")

  if (!all(names == names[1])) error("mcmcr components must have the same names")

  for (i in seq_along(mcmcr)) {
    mcmcr[[i]] <- mcmcr[[i]][[1]][,,data[[paste0("..ID", i)]], drop = FALSE]
    class(mcmcr[[i]]) <- "mcmcarray"
  }

  mcmcr <- combine_values_list(mcmcr, fun = fun)

  data <- data[!grepl("^[.][.]ID", colnames(data))]
  mcmcr <- list(mcmcr)
  names(mcmcr) <- names[1]

  class(mcmcr) <- "mcmcr"

  x <- mcmcr_data(mcmcr, data)

  check_mcmcr_data(x)
  x
}

#' Combine pair of mcmcr_data
#'
#' @inheritParams mcmcr::combine_values
#' @param by A character vector of variables to join by
#' @param suffix If there are non-joined duplicate variables in x and y, these suffixes will be added to the output to diambiguate them.
#' @export
combine_values.mcmcr_data <- function(x, x2, fun = mean, by = NULL, suffix = c(".x", ".y"), ...) {
  if (!is.mcmcr_data(x2)) error("x2 must be an mcmcr_data")
  combine_values_mcmcr_data(list(x, x2), fun = fun, by = by, suffix = suffix)
}
