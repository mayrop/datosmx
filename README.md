# Mexico Datasets - R Package 🇲🇽
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

The R package datosmx 🇲🇽.

I am in process of building an R package to get data about the Novel Coronavirus COVID-19 pandemic cases in Mexico and other datasets.

* Data comes from official sources, more information [here](https://github.com/mayrop/datos-covid19in-mx)

**Warning:** This package is under construction!! 🚧 🚧 🚧 

## Installation
```R
if (!"remotes" %in% installed.packages()) {
  install.packages("remotes")
}
remotes::install_github("mayrop/datosmx")
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

### License
This package is free and open source software, licensed under GPL.


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