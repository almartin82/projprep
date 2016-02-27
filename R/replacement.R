
#' Finds the mlbid of the replacement player, for each position
#'
#' @param pp_list named list of zscored stats. look at `proj_prep` to see
#' where this function gets called
#' @param hit_pitch c('h', 'p')
#'
#' @return named list, with mlbids of replacement player per-position
#' @export

find_replacement <- function(pp_list, hit_pitch) {

  initial_message <- sprintf(
      'finding replacement-level player, assuming %s teams.\n',
      user_settings$league_size
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
