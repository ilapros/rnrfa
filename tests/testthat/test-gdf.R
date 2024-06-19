context("Test gdf function")

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


    
test_that("Output of gdf function for id 18019", {
  skip_if(api_unavailable(), "API not available")
  # All defaults
  x1 <- gdf(id = 18019, metadata = FALSE, cl = NULL)
  expect_true("zoo" %in% class(x1))
  expect_true(all(dim(x1) >= c(731, 1)))

  x2 <- gdf(id = 18019, metadata = TRUE, cl = NULL)
  expect_true("list" %in% class(x2))
  expect_equal(length(x2), 2)

})

test_that("get_ts gdf works in parallel", {
  
  skip_if(api_unavailable(), "API not available")
  skip_on_os("windows")

  s <- try(gdf(id = c(54022, 54090, 54091), cl = 3), silent = TRUE)
  expect_equal(class(s), "try-error")

  cl <- parallel::makeCluster(getOption("cl.cores", 1))
  s <- gdf(id = c(54022, 54090, 54091), cl = cl)
  parallel::stopCluster(cl)
  expect_equal(length(s), 3)

})
