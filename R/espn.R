#' get ESPN adp
#'
#' @return data frame with names and adp
#' @export

espn_adp <- function() {

  espn_adp <- "http://games.espn.go.com/flb/livedraftresults"
  adp <- readHTMLTable(espn_adp)
  adp <- as.data.frame(adp[2])

  adp
}
