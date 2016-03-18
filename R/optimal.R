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


stat_extract_all <- function(x, stat, hit_pitch, replacement_filter = 0) {
  x %>% magrittr::extract2(paste0(hit_pitch, '_final')) %>%
    dplyr::filter(final_zsum >= replacement_filter) %>%
    dplyr::select_(stat) %>%
    magrittr::extract2(1)
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
    dplyr::select_(stat) %>%
    magrittr::extract2(1)
}

