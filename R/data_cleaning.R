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
#' @param strip_unmatched drop positions that aren't in the priority list?
#' useful for weirdo stray eligibility (ie a P that also has OF elig)
#'
#' @return single most scarce position for this player, character
#' @export

priority_position <- function(
  player_positions, priorities, strip_unmatched = TRUE
  ) {

  player_positions <- strsplit(player_positions, ',\\s?') %>% unlist()
  if (strip_unmatched) {
    player_positions <- player_positions[player_positions %in% priorities]
  }
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



#' clean pos
#'
#' @description converts invalid position types to valid
#' @param x vector of positions
#'
#' @return cleaned character vector
#' @export

clean_pos <- function(x) {

  #eg 2016 Mpho' Ngoepe, fantasy pros
  out <- gsub('IF', '2B', x, ignore.case = TRUE)

  return(out)
}


#' clean P
#'
#' @description treat solo 'P' as 'SP
#' @param x vector of positions
#'
#' @return cleaned vector of positions
#' @export

clean_p <- function(x) {

  gsub('\\w*(?<!S|R)P', 'SP', x, perl = TRUE)
}

#' calc_tb
#'
#' @param h total hits
#' @param doubles num doubles
#' @param triples num triples
#' @param hr num homers
#'
#' @return numeric vector
#' @export

calc_tb <- function(h, doubles, triples, hr) {

  h + doubles + (2 * triples) + (3 * hr)
}
