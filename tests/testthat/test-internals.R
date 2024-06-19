context("test-internals.R")

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



test_that("internal fails when it should", {
  skip_if(api_unavailable(), "API not available")
  parameters <- list(format = "json-object", station = "*", fields = "all")
  response <- try(nrfa_api(webservice = "stations-info", parameters),
                  silent = TRUE)
  expect_equal(class(response), "try-error")
})
