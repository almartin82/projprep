#' Read raw cheatsheet projections, given a path to the download file
#'
#' @description reads the cheatsheet projections.
#' these are are free, but the file requires user input/customization,
#' so I'm treating them the same as the paid projections.
#' @inheritParams read_raw_pod
#'
#' @return named list of data frames
#' @export

read_raw_cheatsheet <- function(path_to_file) {

  cheatsheet_h <- readxl::read_excel(
    path = path_to_file, sheet = 2
  )
  cheatsheet_p <- readxl::read_excel(
    path = path_to_file, sheet = 3
  )

  list('h' = cheatsheet_h, 'p' = cheatsheet_p)
}
