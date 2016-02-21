#' Splits firstlast player name into first, last
#'
#' @param x player name, firstlast format ('Barack Obama')
#'
#' @return named list, with first and last name
#' @export

split_firstlast <- function(x) {
  first_whitespace <- "^(\\w+)\\s?(.*)$"

  first_name <- sub(first_whitespace, "\\1", x)
  last_name <- sub(first_whitespace, "\\2", x)

  list('first' = first_name, 'last' = last_name)
}
