ex_dlm_cpred <- function() {
  set.seed(212)
  d <- tibble::tibble(lag0 = rnorm(n = 100, mean = 0.3, sd = 1))
  d <- dplyr::mutate(d,
    lag1 = rnorm(n = 100, mean = lag0, sd = 1),
    lag2 = rnorm(n = 100, mean = lag1, sd = 1),
    lag3 = rnorm(n = 100, mean = lag2, sd = 1),
    lag4 = rnorm(n = 100, mean = lag3, sd = 1),
    lag5 = rnorm(n = 100, mean = lag4, sd = 1),
    lag6 = rnorm(n = 100, mean = lag5, sd = 1),
    lag7 = rnorm(n = 100, mean = lag6, sd = 1),
    lag8 = rnorm(n = 100, mean = lag7, sd = 1),
    lag9 = rnorm(n = 100, mean = lag8, sd = 1),
    y = rnorm(100, mean = 53.5 + 2 * (lag3 + lag4), sd = 10)
  )

  Q <- dplyr::select(d, lag0:lag9)

  cb <- dlnm::crossbasis(Q,
    lag = 9,
    argvar = list("lin"),
    arglag = list(fun = "integer")
  )
  mod <- lm(y ~ cb, data = d)
  cpred <- dlnm::crosspred(cb, mod, at = 1, cumul = TRUE)
  return(cpred)
}

ex_dlnm_cpred <- function() {
  set.seed(212)
  d <- tibble::tibble(lag0 = rnorm(n = 100, mean = 0.3, sd = 1))
  d <- dplyr::mutate(d,
    lag1 = rnorm(n = 100, mean = lag0, sd = 1),
    lag2 = rnorm(n = 100, mean = lag1, sd = 1),
    lag3 = rnorm(n = 100, mean = lag2, sd = 1),
    lag4 = rnorm(n = 100, mean = lag3, sd = 1),
    lag5 = rnorm(n = 100, mean = lag4, sd = 1),
    lag6 = rnorm(n = 100, mean = lag5, sd = 1),
    lag7 = rnorm(n = 100, mean = lag6, sd = 1),
    lag8 = rnorm(n = 100, mean = lag7, sd = 1),
    lag9 = rnorm(n = 100, mean = lag8, sd = 1),
    y = rnorm(100, mean = 53.5 + 2 * (lag3 + lag4), sd = 10)
  )

  Q <- dplyr::select(d, lag0:lag9)

  cb <- dlnm::crossbasis(Q,
    lag = 9,
    argvar = list(fun = "ns", df = 3),
    arglag = list(fun = "ns", df = 3)
  )
  mod <- lm(y ~ cb, data = d)
  cpred <- dlnm::crosspred(cb, mod, cumul = TRUE)
  return(cpred)
}

save_png <- function(code, width = 400, height = 400) {
  path <- tempfile(fileext = ".png")
  png(path, width = width, height = height)
  on.exit(dev.off())
  code

  path
}

expect_snapshot_plot <- function(name, code) {
  name <- paste0(name, ".png")

  # Announce the file before touching `code`. This way, if `code`
  # unexpectedly fails or skips, testthat will not auto-delete the
  # corresponding snapshot file.
  announce_snapshot_file(name = name)

  path <- save_png(code)
  expect_snapshot_file(path, name)
}

# lag_fits <- tidy_lag_fits(ex_dlm_cpred())
#
# tidy_lag_plot(lag_fits, continuous = FALSE) +
#   ylab("Estimate") +
#   theme_minimal()
#
# cumul_fits <- tidy_cumul_fits(cpred)
# tidy_lag_plot(cumul_fits)