

set_defaults <- function() {
  h <- c('r', 'rbi', 'sb', 'tb', 'obp')
  p <- c('w', 'sv', 'k', 'era', 'whip')

  position_hierarchy <- c('C', 'SS', '2B', '3B', 'OF', '1B')

  user_settings <- list(site = 'yahoo','h' = h, 'p' = p)
  save(user_settings, file = 'data/user_settings.rda')
}
