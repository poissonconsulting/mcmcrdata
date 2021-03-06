% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coef.R
\name{coef.mcmcr_data}
\alias{coef.mcmcr_data}
\title{Coef mcmcr data}
\usage{
\method{coef}{mcmcr_data}(object, conf_level = 0.95, ...)
}
\arguments{
\item{object}{The mcmcr_data object.}

\item{conf_level}{A number specifying the confidence level. By default 0.95.}

\item{...}{Not used.}
}
\value{
A tidy tibble of the coefficient terms.
}
\description{
Coefficients for an mcmcr_data object.
}
