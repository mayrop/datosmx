#' Get the table of daily cases for COVID
#'
#' @param date Needs to be provided in ISO format YYYY-MM-DD.
#'   Note that you might need to add
#'   Sys.setenv(TZ = "America/Mexico_City") if you are in a
#'   different timezone. You can specify "today" but it is
#'   better to leave it to the default "latest"
#' @param dataset could be open, or "ctd", "ctd" stands for
#'   "Comunicado Tecnico Diario" (Daily Technical Release).
#'   The open data only exists after April 13th, 2020.
#' @param subset if dataset ctd is preferred, you need to select
#'   a subset (positive or suspected), otherwise this argument
#'   is ignored. In the future they may be condensed into a
#'   single dataset
#'
#' @keywords covid19, mexico, daily cases
#'
#' @export
get_covid_cases <- function(date="latest", dataset="open", subset="positive") {
  result <- get_covid_cases_meta(date, dataset, subset)

  if (isFALSE(result$isAvailable)) {
    stop(paste0("File is not available for: ", date, " ", dataset, " dataset"))
  }

  domain <- "https://datos.covid19in.mx"
  url <- paste0(domain, result$meta$File)

  if (result$meta$Extension == "zip") {
    temp <- tempfile()
    basename <- gsub(".zip", ".csv", basename(url))
    download.file(url, temp)
    df <- read.csv(unz(temp, basename))
    unlink(temp)
  } else {
    df <- read.csv(url)

    if (dataset == "open") {
      validate_covid_structure(df, stop = TRUE)
    }
  }

  df
}


#' Get the table of daily cases for COVID
#'
#'
#' @keywords covid19, mexico, daily cases
#'
#' @export
get_covid_meta <- function() {
  file <- "https://datos.covid19in.mx/meta/files.csv"
  read.csv(file, stringsAsFactors = FALSE)
}


#' Get the meta for specific date, datset & subset
#'
#' @param date Needs to be provided in ISO format YYYY-MM-DD.
#'   Note that you might need to add
#'   Sys.setenv(TZ = "America/Mexico_City") if you are in a
#'   different timezone. You can specify "today" but it is
#'   better to leave it to the default "latest"
#' @param dataset could be open, or "ctd", "ctd" stands for
#'   "Comunicado Tecnico Diario" (Daily Technical Release).
#'   The open data only exists after April 13th, 2020.
#' @param subset if dataset ctd is preferred, you need to select
#'   a subset (positive or suspected), otherwise this argument
#'   is ignored. In the future they may be condensed into a
#'   single dataset
#'
#' @keywords covid19, mexico, daily cases
#'
#' @export
get_covid_cases_meta <- function(date="latest", dataset="open",
                                 subset="positive") {
  if (date == "today") {
    # Get today's date
    date <- format(Sys.Date(), format = "%Y-%m-%d")
  }

  if (!grepl("\\d{4}-\\d{2}-\\d{2}", date) & date != "latest") {
    stop(paste0("Date was provided in invalid format, try: YYYY-MM-DD: ", date))
  }

  if (!(dataset %in% c("open", "ctd"))) {
    stop("Invalid dataset, try: open, ctd")
  }

  if (!(subset %in% c("positive", "suspected"))) {
    stop("Invalid subset, try: positive, suspected")
  }

  meta <- get_covid_meta()

  if (dataset == "open") {
    dataset <- "abiertos"

    if (date == "latest") {
      # we extract latest file
      file <- meta[meta$Type == dataset, ]
      file <- file[1, ]
    } else {
      file <- meta[meta$Type == dataset & meta$Date == date, ]
    }

    all <- meta[meta$Type == dataset, ]
  } else {
    # dataset is ctv
    dataset <- "tablas_diarias"

    subset <- gsub("positive", "positivos", subset)
    subset <- gsub("suspected", "sospechosos", subset)
    if (date == "latest") {
      # we extract latest file
      file <- meta[meta$Type == dataset & meta$Subtype == subset, ]
      file <- file[1, ]
    } else {
      file <- meta[
        meta$Type == dataset & meta$Date == date & meta$Subtype == subset,
      ]
    }
    all <- meta[meta$Type == dataset & meta$Subtype == subset, ]
  }

  return(
    list(
      isAvailable = ifelse(nrow(file) == 1, TRUE, FALSE),
      meta = file,
      last = all[1:5, ]
    )
  )
}


#' Get time series for COVID-19 Cases in MX
#'
#' @keywords covid19, mexico, timeseries
#' @export
get_covid_timeseries <- function() {
  # todo - add option to hardcode URL
  # todo - documentation
  url <- "https://datos.covid19in.mx/series-de-tiempo/agregados/federal.csv"

  read.csv(url, stringsAsFactors = FALSE)
}


#' Gets the open data descriptions
#'
#' @keywords covid19, mexico, daily cases
#'
#' @export
get_covid_descriptions <- function() {
  file <- "https://datos.covid19in.mx/abiertos/descriptores.yaml"
  lapply(yaml::read_yaml(file), as.data.frame)
}


#' Joins open data with the descriptions
#'
#' @keywords covid19, mexico, daily cases
#' @import dplyr
#' @export
complete_covid_cases <- function(cases, descriptions) {

  cases <- rename_old_covid_columns(cases, warnings = TRUE)
  validate_covid_structure(cases, stop = TRUE)

  cases %>%
    dplyr::left_join(descriptions$origin,
                     by = c("ORIGEN" = "CLAVE")) %>%
    dplyr::rename(
      ORIGEN_FACTOR = DESCRIPCION
    ) %>%
    # adding sector
    dplyr::left_join(descriptions$sector,
                     by = c("SECTOR" = "CLAVE")) %>%
    dplyr::rename(
      SECTOR_FACTOR = DESCRIPCION
    ) %>%
    # adding state that gave attention
    dplyr::left_join(descriptions$states,
                     by = c("ENTIDAD_UM" = "CLAVE_ENTIDAD")) %>%
    dplyr::rename(
      ENTIDAD_UM_FACTOR = ENTIDAD_FEDERATIVA
    ) %>%
    dplyr::select(-ABREVIATURA) %>%
    # adding sex
    dplyr::left_join(descriptions$sex,
                     by = c("SEXO" = "CLAVE")) %>%
    dplyr::rename(
      SEXO_FACTOR = DESCRIPCION
    ) %>%
    # adding state where patient was born
    dplyr::left_join(descriptions$states,
                     by = c("ENTIDAD_NAC" = "CLAVE_ENTIDAD")) %>%
    dplyr::rename(
      ENTIDAD_NAC_FACTOR = ENTIDAD_FEDERATIVA
    ) %>%
    dplyr::select(-ABREVIATURA) %>%
    # adding patient's state of residency
    dplyr::left_join(descriptions$states,
                     by = c("ENTIDAD_RES" = "CLAVE_ENTIDAD")) %>%
    dplyr::rename(
      ENTIDAD_RES_FACTOR = ENTIDAD_FEDERATIVA
    ) %>%
    dplyr::select(-ABREVIATURA) %>%
    # adding patient's city of residency
    dplyr::left_join(descriptions$cities,
                     by = c("ENTIDAD_RES" = "CLAVE_ENTIDAD",
                            "MUNICIPIO_RES" = "CLAVE_MUNICIPIO")) %>%
    dplyr::rename(
      MUNICIPIO_RES_FACTOR = MUNICIPIO
    ) %>%
    # adding patient's type
    dplyr::left_join(descriptions$patient_type,
                     by = c("TIPO_PACIENTE" = "CLAVE")) %>%
    dplyr::rename(
      TIPO_PACIENTE_FACTOR = DESCRIPCION
    ) %>%
    # ? intubated
    dplyr::left_join(descriptions$yes_no,
                     by = c("INTUBADO" = "CLAVE")) %>%
    dplyr::rename(
      INTUBADO_FACTOR = DESCRIPCION
    ) %>%
    # ? pneumonia
    dplyr::left_join(descriptions$yes_no,
                     by = c("NEUMONIA" = "CLAVE")) %>%
    dplyr::rename(
      NEUMONIA_FACTOR = DESCRIPCION
    ) %>%
    # ? pregnant
    dplyr::left_join(descriptions$yes_no,
                     by = c("EMBARAZO" = "CLAVE")) %>%
    dplyr::rename(
      EMBARAZO_FACTOR = DESCRIPCION
    ) %>%
    # ? speaks native language
    dplyr::left_join(descriptions$yes_no,
                     by = c("HABLA_LENGUA_INDIG" = "CLAVE")) %>%
    dplyr::rename(
      HABLA_LENGUA_INDIG_FACTOR = DESCRIPCION
    ) %>%
    # ? diabetes
    dplyr::left_join(descriptions$yes_no,
                     by = c("DIABETES" = "CLAVE")) %>%
    dplyr::rename(
      DIABETES_FACTOR = DESCRIPCION
    ) %>%
    # ? epoc
    dplyr::left_join(descriptions$yes_no,
                     by = c("EPOC" = "CLAVE")) %>%
    dplyr::rename(
      EPOC_FACTOR = DESCRIPCION
    ) %>%
    # ? asthma
    dplyr::left_join(descriptions$yes_no,
                     by = c("ASMA" = "CLAVE")) %>%
    dplyr::rename(
      ASMA_FACTOR = DESCRIPCION
    ) %>%
    # ? immunosuppression
    dplyr::left_join(descriptions$yes_no,
                     by = c("INMUSUPR" = "CLAVE")) %>%
    dplyr::rename(
      INMUSUPR_FACTOR = DESCRIPCION
    ) %>%
    # ? hypertension
    dplyr::left_join(descriptions$yes_no,
                     by = c("HIPERTENSION" = "CLAVE")) %>%
    dplyr::rename(
      HIPERTENSION_FACTOR = DESCRIPCION
    ) %>%
    # ? other diseases
    dplyr::left_join(descriptions$yes_no,
                     by = c("OTRA_COM" = "CLAVE")) %>%
    dplyr::rename(
      OTRA_COM_FACTOR = DESCRIPCION
    ) %>%
    # ? cardiovascular
    dplyr::left_join(descriptions$yes_no,
                     by = c("CARDIOVASCULAR" = "CLAVE")) %>%
    dplyr::rename(
      CARDIOVASCULAR_FACTOR = DESCRIPCION
    ) %>%
    # ? obesity
    dplyr::left_join(descriptions$yes_no,
                     by = c("OBESIDAD" = "CLAVE")) %>%
    dplyr::rename(
      OBESIDAD_FACTOR = DESCRIPCION
    ) %>%
    # ? renal chronic
    dplyr::left_join(descriptions$yes_no,
                     by = c("RENAL_CRONICA" = "CLAVE")) %>%
    dplyr::rename(
      RENAL_CRONICA_FACTOR = DESCRIPCION
    ) %>%
    # ? smoker
    dplyr::left_join(descriptions$yes_no,
                     by = c("TABAQUISMO" = "CLAVE")) %>%
    dplyr::rename(
      TABAQUISMO_FACTOR = DESCRIPCION
    ) %>%
    # ? contact with other case?
    dplyr::left_join(descriptions$yes_no,
                     by = c("OTRO_CASO" = "CLAVE")) %>%
    dplyr::rename(
      OTRO_CASO_FACTOR = DESCRIPCION
    ) %>%
    # ? migrant
    dplyr::left_join(descriptions$yes_no,
                     by = c("MIGRANTE" = "CLAVE")) %>%
    dplyr::rename(
      MIGRANTE_FACTOR = DESCRIPCION
    ) %>%
    # ? uci
    dplyr::left_join(descriptions$yes_no,
                     by = c("UCI" = "CLAVE")) %>%
    dplyr::rename(
      UCI_FACTOR = DESCRIPCION
    ) %>%
    # adding result factor
    dplyr::left_join(descriptions$result,
                     by = c("RESULTADO" = "CLAVE")) %>%
    dplyr::rename(
      RESULTADO_FACTOR = DESCRIPCION
    ) %>%
    # adding nationality
    dplyr::left_join(descriptions$nationality,
                     by = c("NACIONALIDAD" = "CLAVE")) %>%
    dplyr::rename(
      NACIONALIDAD_FACTOR = DESCRIPCION
    )
}


#' Fixes structure prior to April 16
#' @import dplyr
rename_old_covid_columns <- function(df, warnings = FALSE) {
  # Renaming variables with typos (prior to April 16)
  if ("HABLA_LENGUA_INDI" %in% names(df)) {
    if (isTRUE(warnings)) {
      warning("Adding HABLA_LENGUA_INDIG variable from HABLA_LENGUA_INDI")
    }

    df <- df %>%
      dplyr::mutate(
        HABLA_LENGUA_INDIG = HABLA_LENGUA_INDI,
      )
  }

  # Renaming variables with typos (prior to April 16)
  if ("OTRA_CON" %in% names(df)) {
    if (isTRUE(warnings)) {
      warning("Adding OTRA_COM variable from OTRA_CON")
    }

    df <- df %>%
      dplyr::mutate(
        OTRA_COM = OTRA_CON,
      )
  }
}


#' Validates structure of dataset
#'
#' @keywords covid19, mexico, daily cases
#' @import dplyr
validate_covid_structure <- function(df, stop = FALSE) {
  cols <- c("FECHA_ACTUALIZACION",
            "ORIGEN",
            "ENTIDAD_UM",
            "SEXO",
            "ENTIDAD_NAC",
            "ENTIDAD_RES",
            "MUNICIPIO_RES",
            "TIPO_PACIENTE",
            "FECHA_INGRESO",
            "FECHA_SINTOMAS",
            "FECHA_DEF",
            "INTUBADO",
            "NEUMONIA",
            "EDAD",
            "NACIONALIDAD",
            "EMBARAZO",
            "HABLA_LENGUA_INDIG",
            "DIABETES",
            "EPOC",
            "ASMA",
            "INMUSUPR",
            "HIPERTENSION",
            "OTRA_COM",
            "CARDIOVASCULAR",
            "OBESIDAD",
            "RENAL_CRONICA",
            "TABAQUISMO",
            "OTRO_CASO",
            "RESULTADO",
            "MIGRANTE",
            "PAIS_NACIONALIDAD",
            "PAIS_ORIGEN",
            "UCI")

  differences <- setdiff(cols, colnames(df))

  if (length(differences) > 0) {
    if (stop) {
      stop(paste0("Could not join, missing columns in dataframe: ",
                  paste0(" ", differences, collapse = ",")))
    } else {
      warning(paste0("Dataset has different structure than usual...
                     missing columns",
                  paste0(" ", differences, collapse = ",")))
    }
  }
}
