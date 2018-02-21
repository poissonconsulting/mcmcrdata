library(mcmcrdata)

mcmcr_example <- mcmcr::mcmcr_example

mcmc_data_example <- mcmc_data(mcmcr_example$alpha, dplyr::starwars[1:2, c("homeworld", "species", "films")])
