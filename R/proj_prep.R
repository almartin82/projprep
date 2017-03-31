#' @title Create a proj_prep object
#'
#' @description given raw projection data, creates a proj_prep object
#'
#' @param proj_list named ('h', 'p') list of data frames, ie output
#' of get_steamer().
#' @param verbose print status updates?
#' default is TRUE
#' @param drop_invalid_pos drop any players whose position cant be parsed.
#' default is TRUE
#' @param catcher_fudge catcher fudge factor
#' @param no_catcher_adjustment use the position-adjusted z-score (FALSE)
#' or use unadjusted z-score (TRUE)
#' @param ... additional arguments
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
  drop_invalid_pos = TRUE,
  catcher_fudge = 1,
  no_catcher_adjustment = TRUE,
  ...
) {

  initial_message <- paste0(
    'building a projection_prep object!\n',
    sprintf('using the following hitting categories: %s',
      paste(user_settings$h, collapse = ', ')
    ),
    '\n',
    sprintf('using the following pitching categories: %s',
            paste(user_settings$p, collapse = ', ')
    ),
    '\n',
    'TODO: to change any of these settings, run `set_defaults()`.',
    '\n'
  )
  message(initial_message)

  #TODO: apply custom positions here

  #determine priority_pos
  proj_list$h <- proj_list$h %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, user_settings$h_hierarchy)
    )
  proj_list$p <- proj_list$p %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, user_settings$p_hierarchy)
    )

  if (drop_invalid_pos) {
    valid_h <- proj_list$h[!is.na(proj_list$h$priority_pos), ]
    valid_p <- proj_list$p[!is.na(proj_list$p$priority_pos), ]

    invalid_pos_message <- paste0(
      'filtering players with invalid positions for your league settings.\n',
      sprintf(
        'filtered %s hitters and %s pitchers.',
        nrow(proj_list$h) - nrow(valid_h),
        nrow(proj_list$p) - nrow(valid_p)
      )
    )
    message(invalid_pos_message)

    proj_list$h <- valid_h
    proj_list$p <- valid_p
  }

  #prep and limit to target stats
  pp_filtered <- limit_proj_vars(proj_list)

  #zscore
  h_zscore <- zscore(
    proj_list = pp_filtered,
    hit_pitch = 'h',
    limit_player_pool = TRUE
  )
  h_with_zscore <- pp_filtered$h %>%
    dplyr::left_join(h_zscore, by = 'mlbid')

  p_zscore <- zscore(
    proj_list = pp_filtered,
    hit_pitch = 'p',
    limit_player_pool = TRUE
  )
  p_with_zscore <- pp_filtered$p %>%
    dplyr::left_join(p_zscore, by = 'mlbid')

  #find replacement by position
  proj_list <- list('h' = h_with_zscore, 'p' = p_with_zscore)

  h_replacement <- find_standard_replacement(proj_list, 'h')
  p_replacement <- find_standard_replacement(proj_list, 'p')
  proj_list[['replacement']] <- list(
    'h' = h_replacement,
    'p' = p_replacement
  )

  h_replacement_special <- find_special_replacement(proj_list, 'h')
  p_replacement_special <- find_special_replacement(proj_list, 'p')

  proj_list[['special_replacement']] <- list(
    'h' = h_replacement_special$replacement_player,
    'p' = p_replacement_special$replacement_player
  )
  proj_list[['replacement_position']] <- list(
    'h' = h_replacement_special$replacement_position,
    'p' = p_replacement_special$replacement_position
  )

  #zscores with replacement position adjustments
  h_plus_replacement <- value_over_replacement(proj_list, 'h')
  p_plus_replacement <- value_over_replacement(proj_list, 'p')

  #catcher fudge factor
  h_plus_replacement <- h_plus_replacement %>%
    dplyr::mutate(
      adjustment_zscore = ifelse(
        replacement_pos == 'C', adjustment_zscore * catcher_fudge, adjustment_zscore
      )
    )

  #catcher over replacement or unadjusted?
  if (no_catcher_adjustment) {
    h_plus_replacement <- h_plus_replacement %>%
      dplyr::mutate(
        final_zsum = ifelse(replacement_pos == 'C', unadjusted_zsum, final_zsum)
      )
  }


  #express as prices
  proj_list[['h_final']] <- h_plus_replacement
  h_with_prices <- calculate_prices(proj_list, 'h')

  proj_list[['p_final']] <- p_plus_replacement
  p_with_prices <- calculate_prices(proj_list, 'p')

  #additional data
  h_with_prices$hit_pitch <- 'h'
  p_with_prices$hit_pitch <- 'p'

  #add final df to lists
  proj_list[['h_final']] <- h_with_prices
  proj_list[['p_final']] <- p_with_prices

  #return
  proj_list
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
  c(common_proj_prep_vars(), 'ab')
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
