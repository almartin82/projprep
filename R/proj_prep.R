#' @title Create a proj_prep object
#'
#' @description given raw projection data, creates a proj_prep object
#'
#' @param proj_list named ('h', 'p') list of data frames, ie output of get_steamer
#' @examples
#'\dontrun{
#' cdf_mv <- mapvizieR(ex_CombinedAssessmentResults,
#'                     ex_CombinedStudentsBySchool)
#'
#' is.mapvizieR(cdf_mv)
#' }
#' @export

proj_prep <- function(proj_list, ...) UseMethod("proj_prep")

#' @export

proj_prep.default <- function(
  proj_list,
  verbose = TRUE,
  ...) {

  initial_message <- paste0(
    'building a projection_prep object.\n',
    sprintf('using the following hitting categories: %s',
      paste(user_settings$h, collapse = ', ')
    ),
    '\n',
    sprintf('using the following pitching categories: %s',
            paste(user_settings$p, collapse = ', ')
    ),
    '\n',
    'to change any of these settings, run `set_defaults()`.'
  )
  message(initial_message)

  #prep and limit to target stats
  pp_filtered <- limit_proj_vars(proj_list)

  #zscore
  h_zscore <- zscore(
    proj_list = pp_filtered,
    hit_pitch = 'h',
    positional = TRUE
  )
  h_with_zscore <- pp_filtered$h %>%
    dplyr::left_join(h_zscore, by = 'mlbid')

  p_zscore <- zscore(
    proj_list = pp_filtered,
    hit_pitch = 'p',
    positional = TRUE
  )
  p_with_zscore <- pp_filtered$p %>%
    dplyr::left_join(p_zscore, by = 'mlbid')

  list('h' = h_with_zscore, 'p' = p_with_zscore)

  #find replacement by position

  #zscore again

  #express as prices

  #return
}


#' What common variables do all projection prep data frames need to have?
#'
#' @return vector with names of common variables
#' @export

common_proj_prep_vars <- function() {
  c('mlbid', 'fullname', 'firstname', 'lastname',
    'position', 'priority_pos', 'projection_name'
  )
}

#' @export
#' @rdname common_proj_prep_vars

common_proj_prep_h_vars <- function() {
  c(common_proj_prep_vars(), 'ab', 'pa')
}

#' @export
#' @rdname common_proj_prep_vars

common_proj_prep_p_vars <- function() {
  c(common_proj_prep_vars(), 'ip')
}


#' select relevant raw projection stats
#'
#' @inheritParams proj_prep
#'
#' @return list of data frames with relevant variables selected
#' @export

limit_proj_vars <- function(proj_list) {

  h_stats <- c(common_proj_prep_h_vars(), user_settings$h)
  h_filtered <- proj_list$h %>%
    dplyr::select(one_of(h_stats))

  p_stats <- c(common_proj_prep_p_vars(), user_settings$p)
  p_filtered <- proj_list$p %>%
    dplyr::select(one_of(p_stats))

  list('h' = h_filtered, 'p' = p_filtered)

}
