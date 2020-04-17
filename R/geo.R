#' Get the cities table
#'
#' @keywords mexico, municipios, cities, poblacion, coordenadas,
#'   population, geographical coordinates
#'
#' @export
get_cities <- function() {
  file <- "https://datos.covid19in.mx/otros/ciudades.csv"
  read.csv(file, stringsAsFactors = FALSE)
}


#' Get the states table
#'
#' @keywords mexico, estados, states, poblacion, coordenadas,
#'   population, states, geographical coordinates
#'
#' @export
get_states <- function() {
  file <- "https://datos.covid19in.mx/otros/estados.csv"
  read.csv(file, stringsAsFactors = FALSE)
}
