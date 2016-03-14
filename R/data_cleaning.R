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

  priority_pos <- priorities[most_scarce]

  #DH is not a real position
  if ('Util' %in% names(user_settings$special_positions$h)) {
    priority_pos <- gsub('DH', 'Util', priority_pos)
  }

  priority_pos
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


#' force numeric
#'
#' @description given a df, and a vector of columns, force those variables
#' from character to numeric
#' @param df data frame
#' @param cols vector of columns that match names in the df
#'
#' @return data frame
#' @export

force_numeric <- function(df, cols) {

  df <- as.data.frame(df, stringsAsFactors = FALSE)

  for(i in cols) {
    mask <- names(df) == i
    df[, mask] <- as.numeric(df[, mask])
  }

  df
}


#' clean quotes from a string
#'
#' @param x character vector
#'
#' @return character vector w/o quotes
#' @export

clean_quotes <- function(x) {

  #see: https://www.cl.cam.ac.uk/~mgk25/ucs/quotes.html
  x <- gsub("\u0022", '', x)
  x <- gsub("\u0027", '', x)
  x <- gsub("\u0060", '', x)
  x <- gsub("\u00B4", '', x)
  x <- gsub("\u2018", '', x)
  x <- gsub("\u2019", '', x)
  x <- gsub("\u201C", '', x)
  x <- gsub("\u201D", '', x)

  #dashes, barf
  x <- gsub("\u2010", '', x)
  x <- gsub("\u2011", '', x)
  x <- gsub("\u2012", '', x)
  x <- gsub("\u2013", '', x)
  x <- gsub("\u2014", '', x)
  x <- gsub("\u2015", '', x)
  x <- gsub("\u2212", '', x)
  x <- gsub("\u002d", '', x)

  x
}


#' force h projection data unique
#'
#' @description some projection systems weirdly include multiple rows
#' per player.  that wreaks havoc down the line.
#' @param clean_df data frame that has been cleaned, eg output of
#' clean_raw_razzball_steamer
#'
#' @return data frame, with one row per id
#' @export

force_h_unique <- function(clean_df) {

  clean_df %>%
    dplyr::ungroup() %>%
    dplyr::group_by(mlbid) %>%
    dplyr::mutate(
      rn = rank(desc(ab), ties.method = 'first')
    ) %>%
    dplyr::filter(rn == 1) %>%
    dplyr::select(-rn)
}


#' force p projection data unique
#'
#' @description some projection systems weirdly include multiple rows
#' per player.  that wreaks havoc down the line.
#' @inheritParams force_h_unique
#'
#' @return data frame, with one row per id
#' @export

force_p_unique <- function(clean_df) {

  clean_df %>%
    dplyr::ungroup() %>%
    dplyr::group_by(mlbid) %>%
    dplyr::mutate(
      rn = rank(desc(ip), ties.method = 'first')
    ) %>%
    dplyr::filter(rn == 1) %>%
    dplyr::select(-rn)
}
