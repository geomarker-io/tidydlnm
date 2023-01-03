test_that("produce tidy table of dlm model fit", {
  expect_snapshot(tidy_lag_fits(ex_dlm_cpred()))
})

# test_that("produce plot", {
#   expect_snapshot_plot("lag_plot", tidy_lag_plot(tidy_lag_fits(ex_dlm_cpred())))
# })

test_that("throw object type error", {
  expect_snapshot(error = TRUE,
                  tidy_lag_fits(1))
})

test_that("throw cumulative fits error", {
  expect_snapshot(error = TRUE,
                  tidy_cumul_fits(cpred = ex_dlm_cpred(cumul = FALSE)))
})
