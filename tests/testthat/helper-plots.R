save_png <- function(code, width = 400, height = 400) {
  path <- tempfile(fileext = ".png")
  grDevices::png(path, width = width, height = height)
  on.exit(dev.off())
  print(code)
  path
}




