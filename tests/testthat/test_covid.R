context("Covid19 Tests")

# need to add
# https://cran.r-project.org/web/packages/httptest/vignettes/httptest.html
test_that("meta file can be retrieved", {
  meta <- get_covid_cases_meta(date = "2020-04-12", dataset = "ctd")
  expect_equal(meta$isAvailable, TRUE)
  expect_equal(meta$meta$Basename, "20200412")
  expect_equal(nrow(meta$last), 5)
})

test_that("meta file can returns false", {
  meta <- get_covid_cases_meta(date = "2020-02-12", dataset = "ctd")
  expect_equal(meta$isAvailable, FALSE)
  expect_equal(nrow(meta$meta), 0)
  expect_equal(nrow(meta$last), 5)
})

test_that("running daily cases without date fails", {
  expect_error(
    get_covid_cases("10-10-2020"),
    "Date was provided in invalid format, try: YYYY-MM-DD")
  expect_error(
    get_covid_cases("2020-04-10"),
    "File is not available for: 2020-04-10 open")
})
