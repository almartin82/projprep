#' calculate prices
#'
#' @description takes zscores over replacement and converts to auction values
#' @inheritParams find_standard_replacement
#'
#' @return data frame, with `value` variable.
#' @export

calculate_prices <- function(pp_list, hit_pitch) {

  initial_message <- sprintf(
    'calculating prices for %s players', hit_pitch
  )
  message(initial_message)

  #grab the df
  this_df <- pp_list %>%
    magrittr::extract2(paste0(hit_pitch, '_final'))

  #get h/p budget split
  pct_budget <- ifelse(
    hit_pitch == 'h', user_settings$pct_budget_h, 1 - user_settings$pct_budget_h
  )
  roster_pct <- ifelse(
    hit_pitch == 'h', user_settings$h_roster_pct, 1 - user_settings$h_roster_pct
  )
  roster_slots <- round(roster_pct *
    (user_settings$league_size * user_settings$roster_size), 0)

  money_avail <- user_settings$team_budget *
    user_settings$league_size * pct_budget
  #account for fact that min bid = 1
  money_avail <- money_avail - roster_slots

  #mask for above replacement players
  above_replacement <- this_df$final_zsum >= 0
  sprintf(
    'there are %s %s players with total value greater than replacement level',
    sum(above_replacement), hit_pitch
  ) %>% message()

  totalz_above_replacement <- sum(this_df[above_replacement, 'final_zsum'])
  dollar_per_z <- money_avail / totalz_above_replacement

  this_df <- this_df %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      value = round(1 + (dollar_per_z * final_zsum), 1)
    )

  this_df
}
