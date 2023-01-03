test_that("create tidy lag plot", {
  skip_on_ci()
  expect_snapshot_file(path = save_png(tidy_lag_plot(tidy_lag_fits(ex_dlm_cpred()))),
                       "dlm_plot.png")
})


test_that("create tidy lag plot non-continuous", {
  skip_on_ci()
  expect_snapshot_file(path = save_png(tidy_lag_plot(tidy_lag_fits(ex_dlm_cpred()), continuous = FALSE)),
                       "dlm_non_continuous_plot.png")
})


# test_that("create tidy lag plot", {
#   save_png(tidy_lag_plot(tidy_lag_fits(ex_dlm_cpred())))
# })
