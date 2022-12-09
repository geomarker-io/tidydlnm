#' get tibble of estimates at each lag
#'
#' @param cpred a crosspred object created from dlnm::crosspred()
#'
#' @return a tibble containing lag, estimate, se, and lower and upper
#'         95% confidence bounds
#' @export
tidy_lag_fits <- function(cpred) {
  tibble::tibble(lag = seq(cpred$lag[1], cpred$lag[2]),
                 estimate = c(cpred$matfit),
                 se = c(cpred$matse),
                 ci_lower = c(cpred$matlow),
                 ci_upper = c(cpred$mathigh),
                 signSum = as.factor(c(sign(ci_lower) + sign(ci_upper))))
}

#' get tibble of overall effect estimate
#'
#' @param cpred a crosspred object created from dlnm::crosspred()
#'
#' @return a tibble containing estimate, se, and lower and upper
#'         95% confidence bounds (1 row)
#' @export
tidy_overall_fit <- function(cpred) {
  tibble::tibble(estimate = c(cpred$allfit),
                 se = c(cpred$allse),
                 ci_lower = c(cpred$alllow),
                 ci_upper = c(cpred$allhigh))
}

#' get tibble of cumulative estimates at each lag
#'
#' @param cpred a crosspred object created from dlnm::crosspred()
#'
#' @return a tibble containing lag, estimate, se, and lower and upper
#'         95% confidence bounds
#' @export
tidy_cumul_fits <- function(cpred) {
  if (!is.null(cpred$cumfit)) {
    tibble::tibble(lag = seq(cpred$lag[1], cpred$lag[2]),
                   estimate = c(cpred$cumfit),
                   se = c(cpred$cumse),
                   ci_lower = c(cpred$cumlow),
                   ci_upper = c(cpred$cumhigh))
  } else {
    cli::cli_alert_warning("Your crosspred object does not contain cumulative fit estimates. Please re-run crosspred with `cumul = TRUE`.")
  }
}
