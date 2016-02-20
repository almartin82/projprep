
zscore <- function(
  df,
  hit_pitch,
  positional = FALSE
  ) {

  this_df <- df %>% magrittr::extract2(hit_pitch)
  this_stats <- user_settings %>% magrittr::extract2(hit_pitch)

  if (positional) {
    position_dummy <- this_df$position
  } else {
    position_dummy <- 'none'
  }

  for (i in this_stats) {

    zscore_df <- data.frame(
      mlbid = this_df$mlbid,
      position = position_dummy,
      stat = this_df %>% magrittr::extract(i) %>% unname(),
      stringsAsFactors = FALSE
    )

    head(zscore_df)

    zscore_df %>%
      dplyr::group_by(position) %>%
      dplyr::mutate(
        zscore = (stat - mean(stat)) / sd(stat)
      )

  }

}


