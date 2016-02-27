

set_defaults <- function() {
  h <- c('r', 'rbi', 'sb', 'tb', 'obp')
  p <- c('w', 'sv', 'k', 'era', 'whip')

  league_size <- 12
  positions <- list(
    'h' = list('C' = 1, '1B' = 1, '2B' = 1, 'SS' = 1, '3B' = 1, 'OF' = 1),
    'p' = list('SP' = 3, 'RP' = 3)
  )

  special_positions <- list(
    'h' = list('Util' = 1),
    'p' = list('P' = 3)
  )

  roster_size <- 27
  h_roster_pct <- 5/9

  position_hierarchy <- c('C', 'SS', '2B', '3B', 'OF', '1B', 'DH', 'SP', 'RP')

  user_settings <- list(
    site = 'yahoo',
    'h' = h, 'p' = p,
    'league_size' = league_size,
    'positions' = positions,
    'special_positions' = positions,
    'roster_size' = roster_size,
    'h_roster_pct' = h_roster_pct,
    'position_hierarchy' = position_hierarchy
  )
  save(user_settings, file = file.path('data', 'user_settings.rda'))
}
