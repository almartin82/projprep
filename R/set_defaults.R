

set_defaults <- function() {
  h <- c('r', 'rbi', 'sb', 'tb', 'obp')
  p <- c('w', 'sv', 'k', 'era', 'whip')
  user_settings <- list(site = 'yahoo','h' = h, 'p' = p)
  save(user_settings, file = 'data/user_settings.rda')
}
