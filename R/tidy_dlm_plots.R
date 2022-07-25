#' plot estimate at each lag and confidence intervals using ggplot2
#'
#' @param lag_fits tibble containing lag, estimate, and lower and upper bounds of
#'                 confidence intervals; most likely output from [tidydlnm::tidy_lag_fits()] or
#'                 [tidydlnm::tidy_cumul_fits()]
#' @param continuous logical. When TRUE, creates a plot with [ggplot2::geom_line()] and [ggplot2::geom_ribbon()]
#'                   (used when `arglag` is a continuous function). When FALSE, creates a plot with
#'                    [ggplot2::geom_pointrange()] (used when `arglag` is not a continuous function -- eg,
#'                    'integer' or 'strata')
#'
#' @return a ggplot object
#' @importFrom ggplot2 ggplot aes geom_pointrange geom_ribbon geom_line geom_hline scale_x_continuous theme_classic xlab ylab
#' @export
tidy_lag_plot <- function(lag_fits, continuous = TRUE) {
  if (!continuous) {
    p <- ggplot(lag_fits) +
      geom_pointrange(aes(x = lag, y = estimate, ymin = ci_lower, ymax = ci_upper))
  } else {
    p <- ggplot(lag_fits) +
      geom_ribbon(aes(ymax = ci_upper, ymin = ci_lower, x = lag, group = 1), alpha = 0.3) +
      geom_line(aes(x = lag, y = estimate, group = 1)) +
      geom_hline(yintercept = 0, linetype = 2)
  }

  p +
    theme_classic() +
    ylab("Regression Coefficient") +
    xlab("Lag") +
    scale_x_continuous(breaks = lag)
}
