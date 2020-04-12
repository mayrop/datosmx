# Covid19in-mx R Package 🇲🇽

### Summary
The R package covid19mx 🇲🇽

```R
install.packages("remotes")
remotes::install_github("mayrop/r-covid19in-mx")
```

###  Contributing

## How to perform static code analysis and style checks
Configuration for lintr is in `.lintr` file. Lints are treated as warnings, but we strive to be lint-free.

In RStudio, you can run lintr from the console as follows:

```R
> lintr::lint_package()
> library(roxygen2)
> library("devtools")
> document()
```

### License
This package is free and open source software, licensed under GPL.

