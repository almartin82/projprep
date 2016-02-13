#' @title Create a proj_prep object
#'
#' @description given raw projection data, creates a proj_prep object
#'
#' @param raw_proj raw projection data.
#' @examples
#'\dontrun{
#' cdf_mv <- mapvizieR(ex_CombinedAssessmentResults,
#'                     ex_CombinedStudentsBySchool)
#'
#' is.mapvizieR(cdf_mv)
#' }
#' @export

proj_prep <- function(raw_proj, ...) UseMethod("proj_prep")

#' @export
proj_prep.default <- function(
  raw_proj,
  league_settings = league_defaults(),
  verbose = TRUE,
  ...) {
  #limit to target stats

  #zscore

  #find replacement by position

  #zscore again

  #express as to prices
}
