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
# retrieving latest data available...
cases <- datosmx::get_covid_cases()
descriptions <- datosmx::get_covid_descriptions()
cases <- 
> str(cases)
'data.frame':   47235 obs. of  34 variables:
 $ FECHA_ACTUALIZACION: Factor w/ 1 level "2020-04-16": 1 1 1 1 1 1 1 1 1 1 ...
 $ ORIGEN             : int  2 2 2 1 2 1 1 1 1 1 ...
 $ SECTOR             : int  9 12 9 12 12 4 12 12 12 12 ...
 $ ENTIDAD_UM         : int  15 9 28 15 9 2 9 9 31 12 ...
 $ SEXO               : int  1 1 2 2 2 2 2 1 2 1 ...
...

all_data <- datosmx::complete_covid_cases(cases, descriptions)

> colnames(all_data)
 [1] "FECHA_ACTUALIZACION"       "ORIGEN"                    "SECTOR"                    "ENTIDAD_UM"               
 [5] "SEXO"                      "ENTIDAD_NAC"               "ENTIDAD_RES"               "MUNICIPIO_RES"            
 [9] "TIPO_PACIENTE"             "FECHA_INGRESO"             "FECHA_SINTOMAS"            "FECHA_DEF"                
[13] "INTUBADO"                  "NEUMONIA"                  "EDAD"                      "NACIONALIDAD"             
[17] "EMBARAZO"                  "HABLA_LENGUA_INDIG"        "DIABETES"                  "EPOC"                     
[21] "ASMA"                      "INMUSUPR"                  "HIPERTENSION"              "OTRA_COM"                 
[25] "CARDIOVASCULAR"            "OBESIDAD"                  "RENAL_CRONICA"             "TABAQUISMO"               
[29] "OTRO_CASO"                 "RESULTADO"                 "MIGRANTE"                  "PAIS_NACIONALIDAD"        
[33] "PAIS_ORIGEN"               "UCI"                       "ORIGEN_FACTOR"             "SECTOR_FACTOR"            
[37] "ENTIDAD_UM_FACTOR"         "SEXO_FACTOR"               "ENTIDAD_NAC_FACTOR"        "ENTIDAD_RES_FACTOR"       
[41] "MUNICIPIO_RES_FACTOR"      "TIPO_PACIENTE_FACTOR"      "INTUBADO_FACTOR"           "NEUMONIA_FACTOR"          
[45] "EMBARAZO_FACTOR"           "HABLA_LENGUA_INDIG_FACTOR" "DIABETES_FACTOR"           "EPOC_FACTOR"              
[49] "ASMA_FACTOR"               "INMUSUPR_FACTOR"           "HIPERTENSION_FACTOR"       "OTRA_COM_FACTOR"          
[53] "CARDIOVASCULAR_FACTOR"     "OBESIDAD_FACTOR"           "RENAL_CRONICA_FACTOR"      "TABAQUISMO_FACTOR"        
[57] "OTRO_CASO_FACTOR"          "MIGRANTE_FACTOR"           "UCI_FACTOR"                "RESULTADO_FACTOR"         
[61] "NACIONALIDAD_FACTOR"      
```

Note for open data prior to April 16, 2020 had typos. New variables are created. So you will receive this warning:
```r
Warning messages:
1: In rename_old_covid_columns(cases, warnings = TRUE) :
  Adding HABLA_LENGUA_INDIG variable from HABLA_LENGUA_INDI
2: In rename_old_covid_columns(cases, warnings = TRUE) :
  Adding OTRA_COM variable from OTRA_CON
```

#### Time Series (going to change soon to include city!)
```r
> datosmx::get_covid_timeseries() %>% head()
       Fecha Estado Positivos Sospechosos Negativos Defunciones Inconsistencias
1 2020-02-27    AGU         0          NA        NA           0              NA
2 2020-02-27    BCN         0          NA        NA           0              NA
3 2020-02-27    BCS         0          NA        NA           0              NA
4 2020-02-27    CAM         0          NA        NA           0              NA
5 2020-02-27    CHH         0          NA        NA           0              NA
6 2020-02-27    CHP         0          NA        NA           0              NA
```

#### Data from Daily Technical Releases
```r
cases <- datosmx::get_covid_cases(dataset = "ctd")
> str(cases)
'data.frame':   6297 obs. of  17 variables:
 $ Caso                      : int  1 2 3 4 5 6 7 8 9 10 ...
 $ Estado                    : chr  "MÉXICO" "TAMAULIPAS" "CIUDAD DE MÉXICO" "CIUDAD DE MÉXICO" ...
 $ Localidad                 : logi  NA NA NA NA NA NA ...
 $ Sexo                      : chr  "FEMENINO" "MASCULINO" "MASCULINO" "FEMENINO" ...
 $ Edad                      : int  75 22 40 29 61 33 77 84 54 65 ...
 $ Fecha_Sintomas            : chr  "28/03/2020" "04/04/2020" "17/03/2020" "26/03/2020" ...
 $ Situacion                 : chr  "Confirmado" "Confirmado" "Confirmado" "Confirmado" ...
...
```


### Generic Datasets (Geo + Population)

#### Cities
```r
cities <- datosmx::get_cities()

> str(cities)
'data.frame': 2458 obs. of  6 variables:
 $ Clave_Entidad  : int  1 1 1 1 1 1 1 1 1 1 ...
 $ Clave_Municipio: int  1 2 3 4 5 6 7 8 9 10 ...
 $ Nombre         : chr  "Aguascalientes" "Asientos" "Calvillo" "Cosío" ...
 $ Longitud       : num  -102 -102 -103 -102 -102 ...
 $ Latitud        : num  21.8 22.1 21.9 22.4 21.9 ...
 $ Poblacion_2019 : int  949277 50354 60181 16766 127835 49479 57359 9551 22468 21710 ...
 
> head(cities)
  Clave_Entidad Clave_Municipio              Nombre  Longitud  Latitud Poblacion_2019
1             1               1      Aguascalientes -102.2958 21.81144         949277
2             1               2            Asientos -102.0456 22.12651          50354
3             1               3            Calvillo -102.7049 21.90069          60181
4             1               4               Cosío -102.2970 22.36063          16766
5             1               5         Jesús María -102.4456 21.93212         127835
6             1               6 Pabellón de Arteaga -102.3017 22.10454          49479
```

#### States
```r
states <- datosmx::get_states()

> str(states)
'data.frame': 32 obs. of  10 variables:
 $ Clave           : int  1 2 3 4 5 6 7 8 9 10 ...
 $ Nombre          : chr  "Aguascalientes" "Baja California" "Baja California Sur" "Campeche" ...
 $ Nombre_Mayuscula: chr  "AGUASCALIENTES" "BAJA CALIFORNIA" "BAJA CALIFORNIA SUR" "CAMPECHE" ...
 $ Nombre_Completo : chr  "Aguascalientes" "Baja California" "Baja California Sur" "Campeche" ...
 $ Abreviatura     : chr  "Ags." "B. C." "B. C. S." "Camp." ...
 $ ISO_3           : chr  "AGU" "BCN" "BCS" "CAM" ...
 $ ISO_2           : chr  "AS" "BC" "BS" "CC" ...
 $ Longitud        : num  -102.4 -115.1 -112.1 -90.4 -102 ...
 $ Latitud         : num  22 30.6 25.9 18.8 27.3 ...
 $ Poblacion_2019  : int  1415421 3578561 788119 984046 3175643 772842 5647532 3765325 9031213 1852952 ...
 
> head(states)
  Clave              Nombre    Nombre_Mayuscula      Nombre_Completo Abreviatura ISO_3 ISO_2   Longitud  Latitud Poblacion_2019
1     1      Aguascalientes      AGUASCALIENTES       Aguascalientes        Ags.   AGU    AS -102.36194 22.00644        1415421
2     2     Baja California     BAJA CALIFORNIA      Baja California       B. C.   BCN    BC -115.09707 30.55159        3578561
3     3 Baja California Sur BAJA CALIFORNIA SUR  Baja California Sur    B. C. S.   BCS    BS -112.06620 25.91871         788119
4     4            Campeche            CAMPECHE             Campeche       Camp.   CAM    CC  -90.36028 18.84055         984046
5     5            Coahuila            COAHUILA Coahuila de Zaragoza       Coah.   COA    CL -102.04404 27.29544        3175643
6     6              Colima              COLIMA               Colima        Col.   COL    CM -104.11512 19.13068         772842
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
  
'data.frame': 2458 obs. of  15 variables:
 $ Clave_Entidad           : int  1 1 1 1 1 1 1 1 1 1 ...
 $ Clave_Municipio         : int  1 2 3 4 5 6 7 8 9 10 ...
 $ Nombre_Municipio        : chr  "Aguascalientes" "Asientos" "Calvillo" "Cosío" ...
 $ Longitud_Municipio      : num  -102 -102 -103 -102 -102 ...
 $ Latitud_Municipio       : num  21.8 22.1 21.9 22.4 21.9 ...
 $ Poblacion_2019_Municipio: int  949277 50354 60181 16766 127835 49479 57359 9551 22468 21710 ...
 $ Nombre_Entidad          : chr  "Aguascalientes" "Aguascalientes" "Aguascalientes" "Aguascalientes" ...
 $ Nombre_Mayuscula_Entidad: chr  "AGUASCALIENTES" "AGUASCALIENTES" "AGUASCALIENTES" "AGUASCALIENTES" ...
 $ Nombre_Completo_Entidad : chr  "Aguascalientes" "Aguascalientes" "Aguascalientes" "Aguascalientes" ...
 $ Abreviatura_Entidad     : chr  "Ags." "Ags." "Ags." "Ags." ...
 $ ISO_3_Entidad           : chr  "AGU" "AGU" "AGU" "AGU" ...
 $ ISO_2_Entidad           : chr  "AS" "AS" "AS" "AS" ...
 $ Longitud_Entidad        : num  -102 -102 -102 -102 -102 ...
 $ Latitud_Entidad         : num  22 22 22 22 22 ...
 $ Poblacion_2019_Entidad  : int  1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 1415421 ...

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

