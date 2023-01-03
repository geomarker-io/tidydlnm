#' plot estimate at each lag and confidence intervals using ggplot2
#'
#' @param lag_fits tibble containing lag, estimate, and lower and upper bounds of
#'                 confidence intervals; most likely output from [`tidydlnm::tidy_lag_fits()``] or
#'                 [`tidydlnm::tidy_cumul_fits()``]
#' @param continuous logical. When TRUE, creates a plot with [`ggplot2::geom_line()`] and [`ggplot2::geom_ribbon()`]
#'                   (used when `arglag` is a continuous function). When FALSE, creates a plot with
#'                    [`ggplot2::geom_pointrange()`] (used when `arglag` is not a continuous function -- eg,
#'                    'integer' or 'strata')
#' @param shading logical. When TRUE, adds colored shading to the regions of the plot
#'                corresponding to significant associations as defined by the signSum
#'                variable of lag_fits
#' @param shade_colors vector of three colors desired to shade the regions of negative, null,
#'                     and positive association, respectively.
#'
#' @return a ggplot object
#' @import ggplot2
#' @export

tidy_lag_plot <- function(lag_fits, continuous = TRUE, shading = FALSE, shade_colors = c("red", NA, "blue")) {

  # non-continuous plot
  if (!continuous) {
    p <- ggplot(lag_fits) +
      geom_pointrange(aes(x = lag, y = estimate, ymin = ci_lower, ymax = ci_upper))
    # continuous plot with shading
  } else if (shading) {
    lag_fits <- lag_fits %>%
      mutate(row_num = 1:dim(lag_fits)[1],
             signSum = as.factor(c(sign(ci_lower) + sign(ci_upper))))
    lag_fits$shade_start <- sapply(lag_fits$row_num, shade_len_start)
    lag_fits$shade_end <- sapply(lag_fits$row_num, shade_len_end)

    shade_key <- tibble(direction = c(-2, 0, 2),
                        color = shade_colors)
    shade_key <- filter(shade_key, direction %in% lag_fits$signSum)
    p <- ggplot(lag_fits) +
      geom_rect(aes(xmin = lag + shade_start, xmax = lag + shade_end, fill = signSum), ymin = -Inf, ymax = Inf, alpha = 0.3) +
      geom_ribbon(aes(ymax = ci_upper, ymin = ci_lower, x = lag, group = 1), fill = "#D4D4D4", inherit.aes = FALSE) +
      geom_line(aes(x = lag, y = estimate, group = 1)) +
      geom_hline(yintercept = 0, linetype = 2) +
      scale_fill_manual(values = shade_key$color, na.value = NA, guide = "none")
    # continuous plot no shading
  } else {
    p <- ggplot(lag_fits) +
      geom_ribbon(aes(ymax = ci_upper, ymin = ci_lower, x = lag, group = 1), alpha = 0.3) +
      geom_line(aes(x = lag, y = estimate, group = 1)) +
      geom_hline(yintercept = 0, linetype = 2)
  }

  p <- p +
    theme_classic() +
    ylab("Regression Coefficient") +
    xlab("Lag") +
    scale_x_continuous(breaks = lag_fits$lag)
  return(p)
}

