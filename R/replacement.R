#' Finds the mlbid of the replacement player, for each standard position
#'
#' @param pp_list named list of zscored stats. look at `proj_prep` to see
#' where this function gets called
#' @param hit_pitch c('h', 'p')
#'
#' @return named list, with mlbids of replacement player per-position
#' @export

find_standard_replacement <- function(pp_list, hit_pitch) {

  initial_message <- sprintf(
      'finding %s replacement-level players, assuming %s teams.',
      hit_pitch, user_settings$league_size
    )
  message(initial_message)

  #find n + 1st player
  pos <- user_settings$positions %>% magrittr::extract2(hit_pitch)
  this_df <- pp_list %>% magrittr::extract2(hit_pitch)

  replacement_player <- list()

  for (i in seq_along(pos)) {
    this_pos <- names(pos[i])

    pos_df <- this_df %>%
      dplyr::filter(
        priority_pos == this_pos
      ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        ranking = rank(desc(zscore_sum), ties.method = 'first')
      )

     num <- pos[i][[1]] * user_settings$league_size
     replacement_id <- pos_df[pos_df$ranking == num + 1, 'mlbid'] %>% unname()
     replacement_player[[this_pos]] <- unlist(replacement_id)
  }

  replacement_player
}


replacement_to_df <- function(pp_list, hit_pitch) {

  replacement_list <- pp_list$replacement %>% magrittr::extract2(hit_pitch)
  this_df <- pp_list %>% magrittr::extract2(hit_pitch)

  r_df <- data.frame(
    position = names(replacement_list),
    mlbid = replacement_list %>% unname() %>% unlist(),
    stringsAsFactors = FALSE
  )
  r_df <- r_df %>%
    dplyr::left_join(
      this_df[, c('mlbid', 'zscore_sum')], by = 'mlbid'
    )

  r_df
}


find_special_replacement <- function(pp_list, hit_pitch) {

  this_df <- pp_list %>% magrittr::extract2(hit_pitch)
  replacement_df <- replacement_to_df(pp_list, hit_pitch)
  special_pos <- user_settings$special_positions %>% magrittr::extract2(hit_pitch)

  #above below regular replacement?
  replacement_df <- replacement_df %>%
    dplyr::select(position, zscore_sum) %>%
    dplyr::rename(
      priority_pos = position,
      replacement_level = zscore_sum
    )

  this_df <- this_df %>%
    dplyr::left_join(
      replacement_df, by = 'priority_pos'
    ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      above_replacement = zscore_sum > replacement_level
    )

  replacement_player <- list()
  for (i in seq_along(special_pos)) {
    pos <- special_pos[i]
    pos_name <- names(pos)

    pos_map <- special_positions_map %>% magrittr::extract2(pos_name)

    pos_matches <- list()
    for (j in pos_map) {
      pos_matches[[j]] <- lapply(this_df$position, function(x) {
        grepl(j, x, fixed = TRUE)
      }) %>% unlist()
    }
    pos_matches <- dplyr::bind_rows(pos_matches)
    this_df$include_test <- rowSums(pos_matches) >= 1

    filter_df <- this_df %>%
      dplyr::filter(
        !above_replacement & include_test
      ) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(
        ranking = rank(desc(zscore_sum), ties.method = 'first')
      )

    num <- special_pos[i][[1]] * user_settings$league_size
    replacement_id <- filter_df[filter_df$ranking == num + 1, 'mlbid'] %>% unname()
    replacement_player[[pos_name]] <- unlist(replacement_id)
  }

  replacement_player
}


foo <- function() {
  f <- get_fantasy_pros(2016)
  proj_list <- f

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
  pp_list <- list('h' = h_with_zscore, 'p' = p_with_zscore)

  h_replacement <- find_standard_replacement(pp_list, 'h')
  p_replacement <- find_standard_replacement(pp_list, 'p')
  pp_list[['replacement']] <- list(
    'h' = h_replacement, 'p' = p_replacement)

  find_special_replacement(pp_list, 'h')
}

#' calculates value over replacement player, by position
#'
#' @inheritParams find_standard_replacement
#'
#' @return data frame, with zscore_replacement value added
#' @export

value_over_replacement <- function(pp_list, hit_pitch) {

  initial_message <- sprintf(
    're-calculating value over %s replacement, by position.', hit_pitch
  )
  message(initial_message)



}
