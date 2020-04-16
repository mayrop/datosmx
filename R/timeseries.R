#' Get time series for COVID-19 Cases in MX
#'
#' @import lubridate
#' @keywords covid19, mexico, timeseries
#' @export
timeseries_all <- function() {
  # todo - add option to hardcode URL
  # todo - documentation
  url <- "https://datos.covid19in.mx/series-de-tiempo/agregados/federal.csv"

  data <- read.csv(url)

  # convert date to ISO format
  data[, "Fecha"] <- lubridate::as_date(data$Fecha)

  data
}

#' Get time series for COVID-19 Cases in MX aggregated by date
#'
#' @import lubridate
#' @keywords covid19, mexico, timeseries
#' @export
timeseries_totals <- function() {
  # todo - add option to hardcode URL
  # todo - documentation
  url <- "https://datos.covid19in.mx/series-de-tiempo/agregados/totales.csv"

  data <- read.csv(url)

  # convert date to ISO format
  data[, "Fecha"] <- lubridate::as_date(data$Fecha)

  data
}
