% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise.R
\name{summarise.mcmcr_data}
\alias{summarise.mcmcr_data}
\title{Summarise mcmcr data}
\usage{
\method{summarise}{mcmcr_data}(.data, ..., .fun = sum)
}
\arguments{
\item{.data}{An mcmcr_data object}

\item{...}{Name-value pairs of summary functions. The name will be the
name of the variable in the result. The value should be an expression
that returns a single value like \code{min(x)}, \code{n()}, or \code{sum(is.na(y))}.

These arguments are automatically \link[rlang:quo]{quoted} and
\link[rlang:eval_tidy]{evaluated} in the context of the data
frame. They support \link[rlang:quasiquotation]{unquoting} and
splicing. See \code{vignette("programming")} for an introduction to
these concepts.}

\item{.fun}{The function to use to summarise the MCMC samples.}
}
\description{
Summarise mcmcr data
}
