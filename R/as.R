#' @export
as.mcarray.mcmcr_data <- function(x, ...) {
  as.mcarray(x$mcmc)
}

#' @export
as.mcmc.mcmcr_data <- function(x, ...) {
  as.mcmc(x$mcmc)
}

#' @export
as.mcmc.list.mcmcr_data <- function(x, ...) {
  as.mcmc.list(x$mcmc)
}

#' @export
as.mcmcarray.mcmcr_data <- function(x, ...) {
  as.mcmcarray(x$mcmc)
}

#' @export
as.mcmcr.mcmcr_data <- function(x, ...) {
  as.mcmcr(x$mcmc)
}

#' @export
as_tibble.mcmcr_data <- function(x, ...) {
  dplyr::as_tibble(x$data)
}

#' @export
as_data_frame.mcmcr_data <- function(x, ...) {
  dplyr::as_data_frame(x$data)
}

#' @export
as.data.frame.mcmcr_data <- function(x, ...) {
  as.data.frame(x$data)
}
