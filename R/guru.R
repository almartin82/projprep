#' Read raw guru projections for a given year
#'
#' @inheritParams read_raw_steamer
#'
#' @return named list of data frames
#' @export

read_raw_guru <- function(year) {

  urls <- list(
    '2016' = 'http://baseballguru.com/GURU_mForecast2016.xls'
  )

  url <- urls[[as.character(year)]]

  tname <- tempfile(pattern = 'guru', tmpdir = tempdir(), fileext = '.xls')
  tdir <- tempdir()
  downloader::download(url, destfile = tname, mode = 'wb')
  guru_p <- readxl::read_excel(path = tname, sheet = 3, skip = 1)
  guru_h <- readxl::read_excel(path = tname, sheet = 4, skip = 1)

  list('h' = guru_h, 'p' = guru_p)
}
