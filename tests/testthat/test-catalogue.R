context("Test catalogue function")

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


test_that("Output of catalogue function is expected to be at least 1539x20", {

  skip_if(api_unavailable(), "API not available")
  catalogueall <- catalogue()
  expect_that(dim(catalogueall) >= c(1580, 99), equals(c(TRUE, TRUE)))

})

test_that("Check output of catalogue for Plynlimon area", {

  skip_if(api_unavailable(), "API not available")
  expect_that(dim(catalogue(bbox = list(lon_min = -3.82, lon_max = -3.63,
                                        lat_min = 52.43, lat_max = 52.52)))[1],
              equals(9))

})

test_that("Check output of catalogue for minimum records of 100 years", {

  skip_if(api_unavailable(), "API not available")
  x <- catalogue(min_rec = 100)

  expect_that(all(c("Lee at Feildes Weir",
                    "Thames at Kingston",
                    "Elan at Caban Dam") %in% x$name), equals(TRUE))

})

test_that("Check the catalogue function fails when it should", {

  skip_if(api_unavailable(), "API not available")
  x <- try(catalogue(column_name = "river"), silent = TRUE)
  expect_equal(class(x), "try-error")

  x <- try(catalogue(column_value = "Wye"), silent = TRUE)
  expect_equal(class(x), "try-error")

})

test_that("Check the catalogue function filters based on column values", {

  skip_if(api_unavailable(), "API not available")
  x <- catalogue(column_name = "river", column_value = "Wye")
  expect_true(dim(x)[1] >= 11)

  x <- catalogue(column_name = "catchment-area", column_value = "<1000")
  expect_true(dim(x)[1] >= 114) #  this is actually 1487 stations, not sure about this test - IP Sept 2022

  x <- catalogue(column_name = "catchment-area", column_value = ">=1000")
  expect_true(dim(x)[1] >= 110) #  was 113, now the result is 112; in Sept 2022 they must have changed some descriptors 
})
