#' Get time series for COVID-19 Cases in MX
#'
#' @param date Needs to be provided in ISO format YYYY-MM-DD
#' @param type could be positive, suspected, positivos, sospechosos
#'
#' @import lubridate
#' @keywords covid19, mexico, daily cases
#' @export
daily_cases <- function(date, type = "positive") {
  if (!grepl("\\d{4}-\\d{2}-\\d{2}", date)) {
    stop(paste0("Date was provided in invalid format, try: YYYY-MM-DD: ", date))
  }

  # verifying it's a valid date
  if (is.na(lubridate::as_date(date))) {
    stop(paste0("Date could not be parsed: ", date))
  }

  if (!(type %in% c("positive", "positivos", "sospechosos", "suspected"))) {
    stop("Invalid type: positive, positivos, sospechosos, suspected")
  }

  type <- gsub("positive", "positivos", type)
  type <- gsub("suspected", "sospechosos", type)

  domain <- "https://datos.covid19in.mx/"
  suffix <- gsub("(\\d{4})-(\\d{2})-(\\d{2})", "\\1\\2/\\1\\2\\3.csv", date)
  path <- paste0("/tablas-diarias/", type, "/", suffix)
  url <- paste0(domain, path)

  # todo - error handling
  read.csv(url)
}
