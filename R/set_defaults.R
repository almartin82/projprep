#' stock defaults
#'
#' @description the out-of-the-box stat/league/auction defaults.
#' unsurprisingly, these currently match the league settings for
#' almartin82's league.
#' @return 'OK' if settings were saved.
#' @export

stock_defaults <- function() {

  h <- c('r', 'rbi', 'sb', 'tb', 'obp')
  h_higher_better <- c(TRUE, TRUE, TRUE, TRUE, TRUE)
  h_rate <- c(FALSE, FALSE, FALSE, FALSE, TRUE)
  p <- c('w', 'sv', 'k', 'era', 'whip')
  p_higher_better <- c(TRUE, TRUE, TRUE, FALSE, FALSE)
  p_rate <- c(FALSE, FALSE, FALSE, TRUE, TRUE)

  league_size <- 12
  positions <- list(
    'h' = list('C' = 1, '1B' = 1, '2B' = 1, 'SS' = 1, '3B' = 1, 'OF' = 3),
    'p' = list('SP' = 3, 'RP' = 3)
  )

  special_positions <- list(
    #order these from most to least constrained
    'h' = list('MI' = 1, 'CI' = 1, 'Util' = 1),
    'p' = list('P' = 3)
  )

  roster_size <- 27
  team_budget <- 270
  #controls how deep into the h player pool we go for initial zscore
  h_roster_pct <- 5/9

  pct_budget_h <- .7

  h_hierarchy <- c('C', 'SS', '3B', '2B', 'OF', '1B', 'DH')
  p_hierarchy <- c('SP', 'RP')

  user_settings <- list(
    site = 'yahoo',
    'h' = h, 'p' = p,
    'h_rate' = h_rate, 'p_rate' = p_rate,
    'h_higher_better' = h_higher_better, 'p_higher_better' = p_higher_better,
    'league_size' = league_size,
    'positions' = positions,
    'special_positions' = special_positions,
    'roster_size' = roster_size,
    'team_budget' = team_budget,
    'h_roster_pct' = h_roster_pct,
    'h_hierarchy' = h_hierarchy,
    'p_hierarchy' = p_hierarchy,
    'pct_budget_h' = pct_budget_h
  )
  save(user_settings, file = file.path('data', 'user_settings.rda'))

  'OK'
}


set_defaults <- function() {

  message(
    paste('I am just a stub!  the ability to edit the default settings',
          'is on the roadmap for projprep 0.3')
  )
}
