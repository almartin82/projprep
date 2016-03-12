

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
