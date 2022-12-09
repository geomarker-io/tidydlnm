#' plot estimate at each lag and confidence intervals using ggplot2
#'
#' @param lag_fits tibble containing lag, estimate, and lower and upper bounds of
#'                 confidence intervals; most likely output from tidy_lag_fits() or
#'                 tidy_cumul_fits()
#' @param continuous logical. When TRUE, creates a plot with geom_line and geom_ribbon (used
#'                    when arglag is a continuous function). When FALSE, creates a plot with
#'                    geom_pointrange (used when arglag is not a continuous function -- eg,
#'                    'integer' or 'strata')
#' @param shading logical. When TRUE, adds colored shading to the regions of the plot
#'                corresponding to significant associations as defined by the signSum
#'                variable of lag_fits
#' @param shade_colors vector of three colors desired to shade the regions of negative, null,
#'                     and positive association, respectively.
#'
#' @return a ggplot object
#' @importFrom ggplot2 ggplot aes geom_pointrange geom_ribbon geom_line geom_hline scale_x_continuous theme_classic xlab ylab
#' @export
tidy_lag_plot <- function(lag_fits, continuous = TRUE, shading = FALSE, shade_colors = c("red", NA, "blue")) {
  if (!continuous) {
    p <- ggplot(lag_fits) +
      geom_pointrange(aes(x = lag, y = estimate, ymin = ci_lower, ymax = ci_upper))
  } else if (shading) {
    shade_key <- tibble(direction = c(-2, 0, 2),
                        color = shade_colors)
    shade_key <- filter(shade_key, direction %in% lag_fits$signSum)
    p <- ggplot(lag_fits) +
      geom_rect(aes(xmin = lag, xmax = lag + 1, fill = signSum), ymin = -Inf, ymax = Inf, alpha = 0.3) +
      geom_ribbon(aes(ymax = ci_upper, ymin = ci_lower, x = lag, group = 1), fill = "#D4D4D4", inherit.aes = FALSE) +
      geom_line(aes(x = lag, y = estimate, group = 1)) +
      geom_hline(yintercept = 0, linetype = 2) +
      scale_fill_manual(values = shade_key$color, na.value = NA, guide = "none")
  } else {
    p <- ggplot(lag_fits) +
      geom_ribbon(aes(ymax=ci_upper, ymin=ci_lower, x=lag, group=1), alpha=0.3) +
      geom_line(aes(x=lag,y=estimate, group=1)) +
      geom_hline(yintercept=0, linetype=2)
  }

  p +
    theme_classic() +
    ylab("Regression Coefficient") +
    xlab("Lag") +
    scale_x_continuous(breaks=lag)
}


