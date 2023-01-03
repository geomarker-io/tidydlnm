shade_len_start <- function(row_num) {
  before <- sum(as.numeric(as.character(lag_fits$signSum[(row_num - 1):row_num])))
  if (row_num == 1) {
    start <- 0
  } else if (before == 2) {
    start <- ((lag_fits$ci_lower[row_num - 1])/(lag_fits$ci_lower[row_num - 1] - lag_fits$ci_lower[row_num])) - 1
  } else if (before == -2) {
    start <- ((lag_fits$ci_upper[row_num - 1])/(lag_fits$ci_upper[row_num - 1] - lag_fits$ci_upper[row_num])) - 1
  } else {
    start <- 0
  }
  return(start)
}

shade_len_end <- function(row_num) {
  after <- sum(as.numeric(as.character(lag_fits$signSum[row_num:(row_num + 1)])))
  if (row_num == dim(lag_fits)[1]) {
    end <- 0
  } else if (after == 2) {
    end <- ((lag_fits$ci_lower[row_num])/(lag_fits$ci_lower[row_num] - lag_fits$ci_lower[row_num + 1]))
  } else if (after == -2) {
    end <- ((lag_fits$ci_upper[row_num])/(lag_fits$ci_upper[row_num] - lag_fits$ci_upper[row_num + 1]))
  } else {
    end <- 1
  }
  return(end)
}
