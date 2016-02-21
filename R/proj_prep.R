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
  h_stats <- c(common_proj_prep_h_vars(), user_settings$h)
  h_filtered <- raw_proj$h %>%
    dplyr::select(one_of(h_stats))

  p_stats <- c(common_proj_prep_p_vars(), user_settings$p)
  p_filtered <- raw_proj$p %>%
    dplyr::select(one_of(p_stats))

  list('h' = h_filtered, 'p' = p_filtered)
  #zscore
  h_zscore <- zscore(
    df = h_filtered,
    hit_pitch = 'h',
    positional = TRUE
  )

  h_zscore
#   h_with_zscore <- h_filtered %>%
#     dplyr::left_join(h_zscore, by = 'mlbid')

#   p_zscore <- zscore(
#     df = p_filtered,
#     hit_pitch = 'p',
#     positional = TRUE
#   )
#   p_with_zscore <- p_filtered %>%
#     dplyr::left_join(p_zscore, by = 'mlbid')


#   list('h' = h_with_zscore)

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
  c('mlbid', 'fullname', 'firstname', 'lastname', 'position', 'priority_pos')
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

