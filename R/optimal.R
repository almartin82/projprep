#' prep name metadata for optimal auction app
#'
#' @param id_map an id map with fields playername, pos, and mlbid.
#' presumably the same id map that is used for `mlbid_match`?
#'
#' @return slim data frame with mlbid, display_name, hit_pitch
#' @export

prep_name_metadata <- function(id_map) {
  #only players with mlbids.  if they don't have a mlbid, handle
  #that using the `universal_metadata` vignette.
  match_df <- id_map %>%
    dplyr::filter(!is.na(mlbid))

  match_df$disp_name <- paste0(match_df$playername, ' (', match_df$pos, ')')

  match_df <- match_df %>%
    dplyr::select(disp_name, mlbid, pos) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      hit_pitch = ifelse(pos %in% c('P', 'RP', 'SP'), 'p', 'h')
    )

  match_df
}


#' find_mlbid
#'
#' @param selected_player display name of the player to look up
#' @param match_df slim data frame to look in.  should include disp_name
#' and mlbid.
#'
#' @return mlbid of matching player
#' @export

find_mlbid <- function(selected_player, match_df) {

  player_match <- match_df %>%
    dplyr::filter(
      disp_name == selected_player
    )

  player_match$mlbid %>% unlist() %>% unname()

}


find_name_metadata <- function(mlbid, match_df, tofind) {
  #nse
  mlbid_in <- mlbid

  player_match <- match_df %>%
    dplyr::filter(mlbid == mlbid_in)

  player_match %>% magrittr::extract2(tofind) %>% unlist() %>% unname()
}



stat_extract_one <- function(x, stat, hit_pitch, replacement_filter = 0) {
  x %>% magrittr::extract2(paste0(hit_pitch, '_final')) %>%
    dplyr::filter(final_zsum >= replacement_filter) %>%
    dplyr::select_(stat) %>%
    magrittr::extract2(1)
}

stat_extract_many <- function(x, stat, hit_pitch, replacement_filter = 0) {
  x %>% magrittr::extract2(paste0(hit_pitch, '_final')) %>%
    dplyr::filter(final_zsum >= replacement_filter) %>%
    dplyr::select(one_of(stat))
}

stat_extract_pos <- function(x, stat, hit_pitch, replacement_filter = 0) {
  x %>% magrittr::extract2(paste0(hit_pitch, '_final')) %>%
    dplyr::filter(final_zsum >= replacement_filter) %>%
    dplyr::select_('priority_pos', stat)
}


stat_extract_player <- function(x, stat, hit_pitch, playerid, replacement_filter = 0) {
  x %>% magrittr::extract2(paste0(hit_pitch, '_final')) %>%
    dplyr::filter(
      final_zsum >= replacement_filter & mlbid == playerid) %>%
    dplyr::select(one_of(stat))
}

