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

  player_positions <- strsplit(player_positions, ',\\s?') %>% unlist()
  tagged <- tag_position(player_positions, priorities)
  most_scarce <- min(tagged)

  priorities[most_scarce]
}


#' clean OF
#'
#' @description converts RF, LF, CF to OF
#' @param x vector of positions
#'
#' @return cleaned character vector
#' @export

clean_OF <- function(x) {

  gsub('RF|CF|LF', 'OF', x, ignore.case = TRUE)
}


