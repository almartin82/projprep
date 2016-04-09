#' get ESPN adp
#'
#' @return data frame with names and adp
#' @export

espn_adp <- function() {

  espn_adp <- "http://games.espn.go.com/flb/livedraftresults"
  adp <- readHTMLTable(espn_adp, stringsAsFactors = FALSE)
  adp <- as.data.frame(adp[2])

  adp_names <- adp[2, ] %>% unlist
  adp <- adp[3:nrow(adp), ]
  names(adp) <- adp_names

  name_team <- strsplit(adp$`PLAYER, TEAM`, ',')
  adp$PLAYER <- lapply(name_team, function(x) extract(x, 1)) %>% unlist()
  adp$TEAM <- lapply(name_team, function(x) extract(x, 2)) %>% unlist()
  adp <- adp[, c(1, 3:10)]
  names(adp) <- c('rank', 'position', 'avg_pick', 'change_7day_pick', 'value',
                  'change_7day_value', 'pct_own', 'player', 'team')

  adp
}
