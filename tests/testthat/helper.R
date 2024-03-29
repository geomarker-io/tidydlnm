ex_dlm_cpred <- function(cumul = TRUE) {
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
  cpred <- dlnm::crosspred(cb, mod, at = 1, cumul = cumul)
  return(cpred)
}

ex_dlnm_cpred <- function(cumul = cumul) {
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
  cpred <- dlnm::crosspred(cb, mod, cumul = cumul)
  return(cpred)
}
