#' Splits firstlast player name into first, last
#'
#' @param x player name, firstlast format ('Barack Obama')
#'
#' @return named list, with first and last name
#' @export

split_firstlast <- function(x) {

  player_names <- strsplit(x, ' ', fixed = TRUE)
  first_name <- lapply(player_names, function(x) extract(x, 1)) %>% unlist()
  last_name <- lapply(player_names, function(x) extract(x, 2)) %>% unlist()

  list('first' = first_name, 'last' = last_name)
}


#' Trim whitespace
#'
#' @param x string or vector of strings
#' @return a string or vector of strings, with whitespace removed.
#' @export

trim_whitespace <- function (x) gsub("^\\s+|\\s+$", "", x)


#' peek
#'
#' @param df a data frame
#'
#' @return just the head of the data frame, all columns visible
#' @export

peek <- function(df) {
  df %>% head() %>% as.data.frame(stringsAsFactors = FALSE)
}

