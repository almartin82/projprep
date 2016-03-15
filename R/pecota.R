#' Read raw pecota projections, given a path to the download file
#'
#' @description reads the BP PECOTA projections.
#' these are paid projections, so this function requires
#' a local path as the argument.
#' @inheritParams read_raw_pod
#'
#' @return named list of data frames
#' @export

read_raw_pecota <- function(path_to_file) {

  pecota_h <- readxl::read_excel(
    path = path_to_file, sheet = 2, skip = 5
  )
  pecota_p <- readxl::read_excel(
    path = path_to_file, sheet = 3, skip = 5
  )

  list('h' = pecota_h, 'p' = pecota_p)
}

