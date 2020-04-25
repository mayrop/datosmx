# Mexico Datasets - R Package 🇲🇽
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

The R package datosmx 🇲🇽.

R package (**Warning:** currently under construction 🚧 🚧 🚧 ) to get data about the Novel Coronavirus COVID-19 pandemic cases in Mexico and other Mexico datasets (geospatial + population). Data comes from official sources, more information [here](https://github.com/mayrop/datos-covid19in-mx).

## Installation
```R
if (!"remotes" %in% installed.packages()) {
  install.packages("remotes")
}
remotes::install_github("mayrop/datosmx")
```

## Usage

### COVID-19 Mexico Dataset
#### Open Data
```r
library(dplyr)

# retrieving latest data available...
cases <- datosmx::get_covid_cases()
## trying URL 'https://datos.covid19in.mx/abiertos/todos/202004/20200424.zip'
## Content type 'application/zip' length 1119907 bytes (1.1 MB)
## ==================================================
## downloaded 1.1 MB

str(cases)
## 'data.frame': 62334 obs. of  35 variables:
## $ FECHA_ACTUALIZACION: Factor w/ 1 level "2020-04-24": 1 1 1 1 1 1 1 1 1 1 ...
## $ ID_REGISTRO        : Factor w/ 62334 levels "000024","000038",..: 20185 60983 30572 2458 18503 54130 62056 53871 57504 39143 ...
## $ ORIGEN             : int  2 2 2 1 1 1 2 2 2 1 ...
## $ SECTOR             : int  9 12 9 3 12 12 4 12 12 4 ...
## $ ENTIDAD_UM         : int  15 9 28 15 15 9 9 9 9 2 ...
##...

descriptions <- datosmx::get_covid_descriptions()
all <- datosmx::complete_covid_cases(cases, descriptions)

all %>% as_tibble()
# A tibble: 62,334 x 62
#   FECHA_ACTUALIZA… ID_REGISTRO ORIGEN SECTOR ENTIDAD_UM  SEXO ENTIDAD_NAC ENTIDAD_RES MUNICIPIO_RES TIPO_PACIENTE
#   <fct>            <fct>        <int>  <int>      <int> <int>       <int>       <int>         <int>         <int>
# 1 2020-04-24       09e8dc           2      9         15     1          15          15            37             2
# 2 2020-04-24       1dd782           2     12          9     1          15           9             3             1
# 3 2020-04-24       0efbaf           2      9         28     2          16          28            32             1
# 4 2020-04-24       013a6c           1      3         15     2          15          15           106             1
# 5 2020-04-24       091a48           1     12         15     2          15          15            31             2
# 6 2020-04-24       1a72fe           1     12          9     1           9           9            11             1
# 7 2020-04-24       1e6142           2      4          9     1           9           9             3             2
# 8 2020-04-24       1a5595           2     12          9     2           9           9             8             1
# 9 2020-04-24       1c21d8           2     12          9     1          15           9             9             1
#10 2020-04-24       13236c           1      4          2     2          21           2             4             2
## … with 62,324 more rows, and 52 more variables: FECHA_INGRESO <fct>, FECHA_SINTOMAS <fct>, FECHA_DEF <fct>,
##   INTUBADO <int>, NEUMONIA <int>, EDAD <int>, NACIONALIDAD <int>, EMBARAZO <int>, HABLA_LENGUA_INDIG <int>,
##   DIABETES <int>, EPOC <int>, ASMA <int>, INMUSUPR <int>, HIPERTENSION <int>, OTRA_COM <int>, CARDIOVASCULAR <int>,
##   OBESIDAD <int>, RENAL_CRONICA <int>, TABAQUISMO <int>, OTRO_CASO <int>, RESULTADO <int>, MIGRANTE <int>,
##   PAIS_NACIONALIDAD <fct>, PAIS_ORIGEN <fct>, UCI <int>, ORIGEN_FACTOR <fct>, SECTOR_FACTOR <fct>,
##   ENTIDAD_UM_FACTOR <fct>, SEXO_FACTOR <fct>, ENTIDAD_NAC_FACTOR <fct>, ENTIDAD_RES_FACTOR <fct>,
##   MUNICIPIO_RES_FACTOR <fct>, TIPO_PACIENTE_FACTOR <fct>, INTUBADO_FACTOR <fct>, NEUMONIA_FACTOR <fct>,
##   EMBARAZO_FACTOR <fct>, HABLA_LENGUA_INDIG_FACTOR <fct>, DIABETES_FACTOR <fct>, EPOC_FACTOR <fct>, ASMA_FACTOR <fct>,
##   INMUSUPR_FACTOR <fct>, HIPERTENSION_FACTOR <fct>, OTRA_COM_FACTOR <fct>, CARDIOVASCULAR_FACTOR <fct>,
##   OBESIDAD_FACTOR <fct>, RENAL_CRONICA_FACTOR <fct>, TABAQUISMO_FACTOR <fct>, OTRO_CASO_FACTOR <fct>,
##   MIGRANTE_FACTOR <fct>, UCI_FACTOR <fct>, RESULTADO_FACTOR <fct>, NACIONALIDAD_FACTOR <fct>

# If you want historical data...
cases <- datosmx::get_covid_cases(date="2020-04-12")
## trying URL 'https://datos.covid19in.mx/abiertos/todos/202004/20200412.zip'
## Content type 'application/zip' length 735960 bytes (718 KB)
## ==================================================
## downloaded 718 KB
```

#### Time Series (going to change soon to include city!)
```r

library(dplyr)
datosmx::get_covid_timeseries() %>% as_tibble()
## # A tibble: 1,856 x 20
## Fecha Estado Positivos Positivos_Delta Sospechosos Sospechosos_Del… Negativos Negativos_Delta
## <chr> <chr>      <int>           <int>       <int>            <int>     <int>           <int>
## 1 2020… AGU            0               0          NA                0        NA               0
## 2 2020… BCN            0               0          NA                0        NA               0
## 3 2020… BCS            0               0          NA                0        NA               0
## 4 2020… CAM            0               0          NA                0        NA               0
## 5 2020… CHH            0               0          NA                0        NA               0
## 6 2020… CHP            0               0          NA                0        NA               0
## 7 2020… CMX            1               0          NA                0        NA               0
## 8 2020… COA            0               0          NA                0        NA               0
## 9 2020… COL            0               0          NA                0        NA               0
## 10 2020… DUR            0               0          NA                0        NA               0
# … with 1,846 more rows, and 12 more variables: Defunciones_Positivos <int>,
#   Defunciones_Positivos_Delta <int>, Defunciones_Sospechosos <int>,
#   Defunciones_Sospechosos_Delta <int>, Defunciones_Negativos <int>,
#   Defunciones_Negativos_Delta <int>, Positivos_Sintomas_14_Dias <int>,
#   Sospechosos_Sintomas_14_Dias <int>, Negativos_Sintomas_14_Dias <int>,
#   Positivos_Sintomas_7_Dias <int>, Sospechosos_Sintomas_7_Dias <int>,
#   Negativos_Sintomas_7_Dias <int>
```

#### Data from Daily Technical Releases (Comunicado Técnico Diario)
Latest update for this dataset is April 18, 2020, the last day the SSa published that dataset.
```r
cases <- datosmx::get_covid_cases(date="2020-04-18", dataset = "ctd")
str(cases)

##'data.frame': 7497 obs. of  17 variables:
## $ Caso                      : int  1 2 3 4 5 6 7 8 9 10 ...
## $ Estado                    : Factor w/ 32 levels "AGUASCALIENTES",..: 15 28 7 7 31 12 7 15 15 19 ...
## $ Localidad                 : logi  NA NA NA NA NA NA ...
## $ Sexo                      : Factor w/ 2 levels "FEMENINO","MASCULINO": 1 2 2 1 2 1 2 1 1 2 ...
## $ Edad                      : int  75 22 40 29 71 61 33 77 84 54 ...
## $ Fecha_Sintomas            : Factor w/ 58 levels "01/03/2020","01/04/2020",..: 54 8 34 50 24 12 10 8 50 39 ...
## $ Situacion                 : Factor w/ 1 level "Confirmado": 1 1 1 1 1 1 1 1 1 1 ...
## $ Procedencia               : logi  NA NA NA NA NA NA ...
## $ Fecha_Llegada             : logi  NA NA NA NA NA NA ...
## $ Estado_Normalizado        : Factor w/ 32 levels "AGU","BCN","BCS",..: 15 28 7 7 31 11 7 15 15 19 ...
## $ Localidad_Normalizado     : logi  NA NA NA NA NA NA ...
## $ Sexo_Normalizado          : Factor w/ 2 levels "F","M": 1 2 2 1 2 1 2 1 1 2 ...
## $ Fecha_Sintomas_Normalizado: Factor w/ 58 levels "2020-02-17","2020-02-19",..: 38 45 27 36 53 47 46 45 36 30 ...
## $ Fecha_Sintomas_Corregido  : logi  NA NA NA NA NA NA ...
## $ Situacion_Normalizado     : Factor w/ 1 level "CONFIRMADO": 1 1 1 1 1 1 1 1 1 1 ...
## $ Procedencia_Normalizado   : logi  NA NA NA NA NA NA ...
## $ Fecha_Llegada_Normalizado : logi  NA NA NA NA NA NA ...
...
```


### Generic Datasets (Geo + Population)

#### Cities
```r
cities <- datosmx::get_cities()

str(cities)
## 'data.frame': 2458 obs. of  6 variables:
##  $ Clave_Entidad  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Clave_Municipio: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Nombre         : chr  "Aguascalientes" "Asientos" "Calvillo" "Cosío" ...
##  $ Longitud       : num  -102 -102 -103 -102 -102 ...
##  $ Latitud        : num  21.8 22.1 21.9 22.4 21.9 ...
## $ Poblacion_2019 : int  949277 50354 60181 16766 127835 49479 57359 9551 22468 21710 ...
 
head(cities)
##   Clave_Entidad Clave_Municipio              Nombre  Longitud  Latitud Poblacion_2019
## 1             1               1      Aguascalientes -102.2958 21.81144         949277
## 2             1               2            Asientos -102.0456 22.12651          50354
## 3             1               3            Calvillo -102.7049 21.90069          60181
## 4             1               4               Cosío -102.2970 22.36063          16766
## 5             1               5         Jesús María -102.4456 21.93212         127835
## 6             1               6 Pabellón de Arteaga -102.3017 22.10454          49479
```

#### States
```r
states <- datosmx::get_states()

str(states)
##'data.frame': 32 obs. of  10 variables:
## $ Clave           : int  1 2 3 4 5 6 7 8 9 10 ...
## $ Nombre          : chr  "Aguascalientes" "Baja California" "Baja California Sur" "Campeche" ...
## $ Nombre_Mayuscula: chr  "AGUASCALIENTES" "BAJA CALIFORNIA" "BAJA CALIFORNIA SUR" "CAMPECHE" ...
## $ Nombre_Completo : chr  "Aguascalientes" "Baja California" "Baja California Sur" "Campeche" ...
## $ Abreviatura     : chr  "Ags." "B. C." "B. C. S." "Camp." ...
## $ ISO_3           : chr  "AGU" "BCN" "BCS" "CAM" ...
## $ RENAPO           : chr  "AS" "BC" "BS" "CC" ...
## $ Longitud        : num  -102.4 -115.1 -112.1 -90.4 -102 ...
## $ Latitud         : num  22 30.6 25.9 18.8 27.3 ...
## $ Poblacion_2019  : int  1415421 3578561 788119 984046 3175643 772842 5647532 3765325 9031213 1852952 ...
 
head(states)
##   Clave              Nombre    Nombre_Mayuscula      Nombre_Completo Abreviatura ISO_3 ISO_2   Longitud  Latitud Poblacion_2019
## 1     1      Aguascalientes      AGUASCALIENTES       Aguascalientes        Ags.   AGU    AS -102.36194 22.00644        1415421
## 2     2     Baja California     BAJA CALIFORNIA      Baja California       B. C.   BCN    BC -115.09707 30.55159        3578561
## 3     3 Baja California Sur BAJA CALIFORNIA SUR  Baja California Sur    B. C. S.   BCS    BS -112.06620 25.91871         788119
## 4     4            Campeche            CAMPECHE             Campeche       Camp.   CAM    CC  -90.36028 18.84055         984046
## 5     5            Coahuila            COAHUILA Coahuila de Zaragoza       Coah.   COA    CL -102.04404 27.29544        3175643
## 6     6              Colima              COLIMA               Colima        Col.   COL    CM -104.11512 19.13068         772842
```

### Joining Cities and States Datasets
```r
cities %>% 
  dplyr::rename_at(vars(Nombre:Poblacion_2019), function(x) {
    paste0(x, "_Municipio")
  }) %>%
  dplyr::left_join(
    states %>%
      dplyr::rename_all(function(x) { paste0(x, "_Entidad")}),
    by = "Clave_Entidad"
  ) %>% 
  str()
  
## 'data.frame': 2458 obs. of  15 variables:
##  $ Clave_Entidad           : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Clave_Municipio         : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Nombre_Municipio        : chr  "Aguascalientes" "Asientos" "Calvillo" "Cosío" ...
##  $ Longitud_Municipio      : num  -102 -102 -103 -102 -102 ...
##  $ Latitud_Municipio       : num  21.8 22.1 21.9 22.4 21.9 ...
##  $ Poblacion_2019_Municipio: int  949277 50354 60181 16766 127835 49479 57359 9551 22468 21710 ...
##  $ Nombre_Entidad          : chr  "Aguascalientes" "Aguascalientes" "Aguascalientes" "Aguascalientes" ...
##  $ Nombre_Mayuscula_Entidad: chr  "AGUASCALIENTES" "AGUASCALIENTES" "AGUASCALIENTES" "AGUASCALIENTES" ...
##  $ Nombre_Completo_Entidad : chr  "Aguascalientes" "Aguascalientes" "Aguascalientes" "Aguascalientes" ...
##  $ Abreviatura_Entidad     : chr  "Ags." "Ags." "Ags." "Ags." ...
##  $ ISO_3_Entidad           : chr  "AGU" "AGU" "AGU" "AGU" ...
##  $ RENAPO_Entidad           : chr  "AS" "AS" "AS" "AS" ...
##  $ Longitud_Entidad        : num  -102 -102 -102 -102 -102 ...
##  $ Latitud_Entidad         : num  22 22 22 22 22 ...
##  $ Poblacion_2019_Entidad  : int  1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 ...

```


##  Contributing

### How to perform static code analysis and style checks
Configuration for lintr is in `.lintr` file. Lints are treated as warnings, but we strive to be lint-free.

In RStudio, you can run lintr from the console as follows:

```R
> lintr::lint_package()
> library(roxygen2)
> library("devtools")
> devtools::document()
```

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://twitter.com/mayrop"><img src="https://avatars0.githubusercontent.com/u/495985?v=4" width="100px;" alt=""/><br /><sub><b>Mayra Valdés</b></sub></a><br /><a href="https://github.com/mayrop/datosmx/commits?author=mayrop" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## License
This package is free and open source software, licensed under GPL.

