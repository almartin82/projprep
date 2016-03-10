#' Read raw guru projections, given a path to the download file
#'
#' @description reads the http://www.projectingx.com/baseball-player-projections/
#' pod projections.  pod projections are paid, so this function requires
#' a local path as the argument.
#' @param path_to_file local path to where the pod projections file is located.
#'
#' @return named list of data frames
#' @export
read_raw_pod <- function(path_to_file) {

  pod_h <- readxl::read_excel(path = path_to_file, sheet = 2)
  pod_p <- readxl::read_excel(path = path_to_file, sheet = 3)

  list('h' = pod_h, 'p' = pod_p)
}


clean_raw_pod <- function(df, hit_pitch) {

}
