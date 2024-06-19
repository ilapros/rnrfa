library("testthat")
library("rnrfa")
# library("lintr")

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

# skip_if_no_api() <- function() {
#   if (api_unavailable()) {
#     skip("API not available")
#   }
# }

if (!curl::has_internet()) {
  message("No internet, cannot run tests")
}else {
  test_check("rnrfa")
}
