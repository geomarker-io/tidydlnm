#' get tibble of estimates at each lag
#'
#' @param cpred a crosspred object created from [`dlnm::crosspred()`]
#' @param call used for error handling
#'
#' @return a tibble with columns for lag, estimate, se, and lower and upper
#'         95% confidence bounds (one row per lag)
#' @export
tidy_lag_fits <- function(cpred, call = rlang::caller_env()) {
  check_cpred(cpred, call = call)

  tibble::tibble(
    lag = seq(cpred$lag[1], cpred$lag[2]),
    estimate = c(cpred$matfit),
    se = c(cpred$matse),
    ci_lower = c(cpred$matlow),
    ci_upper = c(cpred$mathigh)
  )
}

#' get tibble of overall effect estimates
#'
#' @inheritParams tidy_lag_fits
#'
#' @return a tibble with columns for estimate, se, and lower and upper
#'         95% confidence bounds (1 row)
#' @export
tidy_overall_fit <- function(cpred, call = rlang::caller_env()) {
  check_cpred(cpred, call = call)

  tibble::tibble(
    estimate = c(cpred$allfit),
    se = c(cpred$allse),
    ci_lower = c(cpred$alllow),
    ci_upper = c(cpred$allhigh)
  )
}

#' get tibble of cumulative estimates at each lag
#'
#' @inheritParams tidy_lag_fits
#'
#' @return a tibble with columns for lag, estimate, se, and lower and upper
#'         95% confidence bounds (one row per lag)
#' @export
tidy_cumul_fits <- function(cpred, call = rlang::caller_env()) {
  check_cpred(cpred, call = call)

  if (!is.null(cpred$cumfit)) {
    tibble::tibble(
      lag = seq(cpred$lag[1], cpred$lag[2]),
      estimate = c(cpred$cumfit),
      se = c(cpred$cumse),
      ci_lower = c(cpred$cumlow),
      ci_upper = c(cpred$cumhigh)
    )
  } else {
    cli::cli_abort(message = c("x" = "Your crosspred object does not contain cumulative fit estimates.",
                               "!" = "Please re-run crosspred with `cumul = TRUE`."))
  }
}


check_cpred <- function(cpred,
                        arg = rlang::caller_arg(cpred),
                        call = rlang::caller_env()) {
  if (! class(cpred) == "crosspred") {
    cli::cli_abort(message = c("x" = "{.arg {arg}} must be of type crosspred",
                               "i" = "see {.url https://github.com/gasparrini/dlnm} for more information about crosspred objects."),
                   call = call)
  }
}

#' get tibble detailing each window of association with summary statistics
#'
#' @param lag_fits tibble containing lag, estimate, and lower and upper bounds of
#'                 confidence intervals; most likely output from tidy_lag_fits() or
#'                 tidy_cumul_fits()
#'
#' @return a tibble containing windows defined by starting and ending lags, window length,
#'         maximum absolute effect estimate, and the lag at which that maximum occurs
#' @export
tidy_window_summary <- function(lag_fits) {
  windows <- lag_fits %>%
    mutate(signSum = sign(ci_lower) + sign(ci_upper)) %>%
    filter(signSum != 0)
  windows$window_id <- cumsum(c(1,diff(windows$lag)) > 1) + 1

  window_boundaries <- windows %>%
    group_by(window_id) %>%
    summarise(min_lag = min(lag),
              max_lag = max(lag)) %>%
    mutate(window_len = max_lag - min_lag + 1)

  window_maximum <- windows %>%
    group_by(window_id) %>%
    filter(abs(estimate) == max(abs(estimate))) %>%
    ungroup() %>%
    rename(max_estimate = estimate) %>%
    select(window_id, max_estimate, se, ci_lower, ci_upper, lag)

  window_summary <- window_boundaries %>%
    left_join(window_maximum, by = "window_id")

  return(window_summary)
}
