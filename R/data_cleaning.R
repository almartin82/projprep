#' tag position priority
#'
#' @param player_positions vector of positions (1 player, not vector of vectors)
#' @param priorities ranked heirarchy, usually from `user_settings`.
#'
#' @return vector of numeric priorities
#' @export

tag_position <- function(player_positions, priorities) {
  positions <- lapply(
    X = player_positions,
    FUN = function(x) match(x, priorities)
  )

  unlist(positions)
}


#' priority position
#'
#' @inheritParams tag_position
#'
#' @return single most scarce position for this player, character
#' @export

priority_position <- function(player_positions, priorities) {
  player_positions <- strsplit(player_positions, ', ') %>% unlist()
  tagged <- tag_position(player_positions, priorities)
  most_scarce <- min(tagged)

  priorities[most_scarce]
}


