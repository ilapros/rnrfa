#' Plot trend
#'
#' @description This function plots a previously calculated trend.
#'
#' @param df Data frame containing at least 4 column:
#' lat (latitude), lon (longitude), slope and an additional user-defined column
#' \code{column_name}.
#' @param column_name name of the column to use for grouping the results.
#' @param maptype maptype, was need to choose the stamenmap type, now useless since
#' stamenmap are no longer reachable 
#' @param showmap set to FALSE to avoid plotting the map when running the function
#'
#' @return Two plots, the first showing the distribution of the
#' trend over a map, based on the slope of the linear model that describes the
#' trend. The second plot shows a boxplot of the slope grouped based on the
#' column \code{column_name} and slope can be user-defined 
#' (notice that in the plot the very extreme slope values are not 
#' displayed to avoid skewed visualisations). 
#' 
#' @details
#' The function relies on the `ggmap` package for the map, and this package has 
#' in time gone through many changes due to changes in API of map providers. 
#' Currently to be able to create the map one needs to register to the stadiamaps
#' serice. More information at ?ggmap::register_stadiamaps(). 
#'  
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   # some fake data around London 
#'   df <- data.frame(lat = 51.5+runif(40,-0.3,0.3), 
#'                    lon = 0+runif(40, -0.3,0.3),
#'                    slope = rnorm(40, c(rep(-0.4,20),rep(0.4,20))), 
#'                    g = factor(c(rep("a",20), rep("b",20))))
#'   theplots <- plot_trend(df, "g", maptype = "terrain-background")
#'   theplots$A # map
#'   theplots$B + labs(subtitle = "Use ggplot usual commands to modify the plots") # boxplots
#'   
#' }

plot_trend <- function(df, column_name, maptype = "stamen_toner_lite", showmap = TRUE) {
  names(df) <- tolower(names(df))
  if(!all(c("lat", "lon") %in% names(df))){
    if(all(c("latitude", "longitude") %in% names(df))) {
      df$lat <- df$latitude; df$lon <- df$longitude
    }
    else stop("need lat lon columns to proceed")
  } 
  df$trend <- NA
  df$trend[df$slope >= 0]  <- "Positive"
  df$trend[df$slope < 0]  <- "Negative"
  
  plot1 <- NULL 
  # To avoid Note in R check
  lon <- lat <- trend <- slope <- NULL

  if(showmap){ ## only create plot1 if map is required 
   
    # Plot red dot for decreasing trend, blue dot for increasing trend
    tolerance <- (max(df$lon, na.rm = TRUE) - min(df$lon, na.rm = TRUE)) / 10
    # m <- ggmap::get_map(location = c(min(df$lon, na.rm = TRUE) - 2 * tolerance,
    #                           min(df$lat, na.rm = TRUE) - 2 * tolerance,
    #                           max(df$lon, na.rm = TRUE) + tolerance,
    #                           max(df$lat, na.rm = TRUE)) + tolerance,
    #              maptype = "toner-lite")
 
    ## form ggmap 
    location <- c(left = min(df$lon, na.rm = TRUE) - 2 * tolerance,
                    bottom = min(df$lat, na.rm = TRUE) - 2 * tolerance,
                    right= max(df$lon, na.rm = TRUE) + tolerance,
                    top = max(df$lat, na.rm = TRUE)) + tolerance
    lon_range <- location[c("left","right")]
    lat_range <- location[c("bottom","top")]

    # compute zoom
    lonlength <- diff(lon_range)
    latlength <- diff(lat_range)
    zoomlon <- ceiling( log2( 360*2 / lonlength) )
    zoomlat <- ceiling( log2( 180*2 / latlength) )
    zoom <- max(zoomlon, zoomlat)
  
  m <- ggmap::get_stadiamap(bbox = location,
               maptype = maptype, zoom = zoom)

  # Plot map
  plot1 <- ggmap::ggmap(m, alpha = 0.5) +
    ggplot2::geom_point(data = df,
                        ggplot2::aes(x = lon, y = lat, colour = trend),
                        alpha = 0.6,  size = 1) +
    ggplot2::scale_color_manual(values = c("Negative" = "red",
                                           "Positive" = "dodgerblue2")) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::ggtitle("A")
  }
  # Boxplot by grouping variable (e.g. NUTS1 region)
  plot2 <- ggplot2::ggplot(df,
                           ggplot2::aes(x = eval(parse(text = column_name)),
                                        y = slope,
                                        group = eval(parse(text =
                                                             column_name)))) +
    ggplot2::geom_boxplot(outlier.shape = NA) +
    ggplot2::scale_y_continuous(limits = stats::quantile(df$slope,
                                                         c(0.05, 0.95))) +
    ggplot2::theme_minimal() + ggplot2::ylab("Slope") + ggplot2::xlab("") +
    ggplot2::coord_flip() +
    ggplot2::theme(plot.margin = ggplot2::unit(c(1, 1, 1, 1.2), "cm"),
                   axis.title.x = ggplot2::element_text(margin =
                                                          ggplot2::margin(10,
                                                                          0,
                                                                          0,
                                                                          0))) +
    ggplot2::ggtitle("B")
  # if(showmap) print(plot1) 
  return(list("A" = plot1, "B" = plot2))

}
