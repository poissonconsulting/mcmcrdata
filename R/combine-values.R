#' Combines object values.
#'
#' Combines mcmc objects by values using fun.
#'
#' @param x An mcmc object.
#' @param x2 A second mcmc object.
#' @param fun A function.
#' @param ... Unused.
#' @export
combine_values <- function(x, x2, fun = mean, ...) {
  UseMethod("combine_values")
}

combine_values_mcmcarray <- function(x, fun) {
  if (!all(vapply(x, is.mcmcarray, TRUE))) error("objects in x must be of class mcmcarray")

  dim <- lapply(x, dim)
  names(dim) <- NULL

  if (!identical(dim, rep(dim[1], length(x))))
    error("objects in x must have the same dimensions")

  x <-abind::abind(x, along = 0)
  x <- apply(x, 2:ndims(x), fun)

  if (!identical(dim[[1]], dim(x))) error("function fun must return a scalar")

  class(x) <- "mcmcarray"
  x
}

combine_values_mcmcr <- function(x, fun) {
  if (!all(vapply(x, is.mcmcr, TRUE))) error("objects in x must be of class mcmcr")

  names <- lapply(x, names)
  if (!all.equal(names, rep(names[1], length(x)), check.names = FALSE)) error("objects in x must have the same names")

  x <- purrr::transpose(x)

  x <- lapply(x, combine_values_mcmcarray, fun = fun)

  class(x) <- "mcmcr"
  x
}

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

  mcmcr <- combine_values_mcmcarray(mcmcr, fun = fun)

  data <- data[!grepl("^[.][.]ID", colnames(data))]
  mcmcr <- list(mcmcr)
  names(mcmcr) <- names[1]

  class(mcmcr) <- "mcmcr"

  x <- mcmcr_data(mcmcr, data)

  check_mcmcr_data(x)
  x
}

#' Combine list of mcmc samples
#'
#' @inheritParams combine_values
#' @param by A character vector of variables to join by if combining mcmcr_data objects.
#' @param suffix If there are non-joined duplicate variables in x and y, these suffixes will be added to the output to diambiguate them if combininig mcmcr_data objects.
#' @export
combine_values_list <- function(x, fun = mean, by = NULL, suffix = c(".x", ".y")) {
  if (length(x) < 2) return(x)

  class <- class(x[[1]])

  x <- switch(class,
              mcmcr_data = combine_values_mcmcr_data(x, fun = fun, by = by, suffix = suffix),
              mcmcr = combine_values_mcmcr(x, fun = fun),
              mcmcarray = combine_values_mcmcarray(x, fun = fun),
              stop("combine_values is not defined for a list of objects of class '", class, "'"))
  x
}

#' @export
combine_values.mcmcarray <- function(x, x2, fun = mean, ...) {
  if (!is.mcmcarray(x2)) error("x2 must be an mcmcarray")
  combine_values_list(list(x, x2), fun = fun)
}

#' @export
combine_values.mcmcr <- function(x, x2, fun = mean, ...) {
  if (!is.mcmcr(x2)) error("x2 must be an mcmcr")
  combine_values_list(list(x, x2), fun = fun)
}

#' Combine pair of mcmcr_data
#'
#' @inheritParams combine_values
#' @param by A character vector of variables to join by
#' @param suffix If there are non-joined duplicate variables in x and y, these suffixes will be added to the output to diambiguate them.
#' @export
combine_values.mcmcr_data <- function(x, x2, fun = mean, by = NULL, suffix = c(".x", ".y"), ...) {
  if (!is.mcmcr_data(x2)) error("x2 must be an mcmcr_data")
  combine_values_list(list(x, x2), fun = fun, by = by, suffix = suffix)
}