context("mcmcr-data")

test_that("mcmcr_data", {

  data <- data.frame(col1 = 1:2, col2 = factor(1:2))
  
  mcmcr <- mcmcr:::mcmcr

  expect_error(mcmcr_data(mcmcr, data), "mcmcr must have just one parameter")
  expect_error(mcmcr_data(subset(mcmcr, parameters = "beta"), data), "mcmcr's parameter must be a vector")
  expect_error(mcmcr_data(subset(mcmcr, parameters = "sigma"), data), "mcmcr's parameter must be the same length as the number of rows in data")
  expect_is(mcmcr_data(subset(mcmcr, parameters = "alpha"), data), "mcmcr_data")
})

test_that("mcmcr_data", {

  data <- dplyr::data_frame(col1 = 1:2, col2 = 3)

  mcmcr <- mcmcr:::mcmcr

  mcmcr <- subset(mcmcr, parameters = "alpha")

  mcmcr_data <- mcmcr_data(mcmcr, data)
  expect_true(is.mcmcr_data(mcmcr_data))

  coef <- coef(mcmcr_data)

  expect_identical(colnames(coef), c("col1", "col2", "term", "estimate", "sd", "zscore", "lower", "upper", "pvalue"))
  expect_identical(as.character(coef$term), c("alpha[1]", "alpha[2]"))

  expect_identical(as.data.frame(mcmcr_data), data)
  expect_identical(mcmcr::as.mcmcr(mcmcr_data), mcmcr)
  
  expect_equal(mcmcr::combine_values(mcmcr_data, mcmcr_data, by = c("col1", "col2")), mcmcr_data,
               check.attributes = FALSE)

  mcmcr_data2 <- dplyr::filter(mcmcr_data, col1 == 1)
  coef2 <- coef(mcmcr_data2)
  expect_identical(as.character(coef2$term), c("alpha"))
  expect_identical(coef2$col1, 1L)

  mcmcr_data3 <- dplyr::left_join(mcmcr_data, mcmcr_data2$data, by = c("col1", "col2"))

  expect_identical(mcmcr_data3, mcmcr_data)

  mcmcr_data3 <- dplyr::inner_join(mcmcr_data, mcmcr_data2$data, by = c("col1", "col2"))

  expect_identical(mcmcr_data3, mcmcr_data2)

  mcmcr_data2 <- dplyr::group_by(mcmcr_data, col2)
  expect_identical(dplyr::ungroup(mcmcr_data2), mcmcr_data)
  expect_identical(as.character(coef(mcmcr_data2)$term), c("alpha[1]", "alpha[2]"))

  expect_error(dplyr::summarise(mcmcr_data), "mcmcr_data must be grouped to summarize")

  coef2 <- coef(dplyr::summarise(mcmcr_data2))
  expect_identical(colnames(coef2), c("col2", "term", "estimate", "sd", "zscore", "lower", "upper", "pvalue"))
  expect_identical(as.character(coef2$term), c("alpha"))

  mcmcr_data2 <- dplyr::group_by(mcmcr_data, col1)
  coef1 <- coef(dplyr::summarise(mcmcr_data2))
  expect_identical(colnames(coef1), c("col1", "term", "estimate", "sd", "zscore", "lower", "upper", "pvalue"))
  expect_identical(as.character(coef1$term), c("alpha[1]", "alpha[2]"))
  coef2 <- coef(dplyr::summarise(mcmcr_data2, .fun = function(x) 10))
  
  mcmcr_data2 <- dplyr::slice_(mcmcr_data, 1)
  expect_identical(mcmcr::nterms(mcmcr_data$mcmcr), 2L)
  expect_identical(mcmcr::nterms(mcmcr_data2$mcmcr), 1L)
})
