context("Test cmr function")

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

test_that("Output of cmr function for single station", {

  skip_if(api_unavailable(), "API not available")
  x <- cmr(id = 18019, metadata = FALSE, cl = NULL)
  expect_true(length(x) >= 660)

  x <- cmr(id = 18019, metadata = TRUE, cl = NULL)
  expect_that(length(x) == 2, equals(TRUE))
  expect_that(x$meta$station.name == "Comer Burn at Comer", equals(TRUE))

})

test_that("Output of cmr function for multiple stations", {

  skip_if(api_unavailable(), "API not available")
  ids <- c(54022, 54090, 54091)

  x <- cmr(id = ids, metadata = FALSE, cl = NULL)

  expect_that(length(x) == 3, equals(TRUE))

  x <- cmr(id = ids, metadata = TRUE, cl = NULL)

  expect_that(length(x) == 3, equals(TRUE))
  expect_that(length(x[[1]]) == 2, equals(TRUE))

  y <- x[[1]]

  expect_that(all(names(y) == c("data", "meta")), equals(TRUE))

})
