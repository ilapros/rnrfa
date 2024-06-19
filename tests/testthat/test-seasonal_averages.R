context("test-seasonal_averages.R")
api_unavailable <- function(){
  resp1 <- httr::GET(url = "https://nrfaapps.ceh.ac.uk/nrfa/ws/time-series", 
                     query = list(format = "json-object", station = 39001,`data-type` = "gdf"), 
                     httr::user_agent("https://github.com/ilapros/rnrfa"))
  resp2 <- httr::GET(url = "https://nrfaapps.ceh.ac.uk/nrfa/ws/time-series", 
                     query = list(format = "json-object", station = 39001,`data-type` = "cmr"), 
                     httr::user_agent("https://github.com/ilapros/rnrfa"))
  # if any of the two streams is not working skip tests 
  (httr::http_error(resp1) | httr::http_error(resp2))
}


test_that("seasonal_averages works", {
  skip_if(api_unavailable(), "API not available")

  x <- seasonal_averages(timeseries = cmr(18019), season = "Spring")
  expect_equal(length(x), 2)
  expect_equal(names(x), c("cmr.Estimate", "cmr.Pr(>|t|)"))

  x <- seasonal_averages(cmr(18019), season = "Summer")
  expect_equal(length(x), 2)

  x <- seasonal_averages(cmr(18019), season = "Autumn")
  expect_equal(length(x), 2)

  x <- seasonal_averages(list(cmr(18019), cmr(18019)), season = "Winter")
  expect_equal(length(x), 2)
  expect_equal(x[1], x[2])

})
