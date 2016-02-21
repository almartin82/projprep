
zscore <- function(
  df,
  hit_pitch,
  positional = FALSE
  ) {

  this_df <- df %>% magrittr::extract2(hit_pitch)
  this_stats <- user_settings %>% magrittr::extract2(hit_pitch)

  if (positional) {
    position_dummy <- this_df$priority_pos
  } else {
    position_dummy <- 'none'
  }

  zscored <- list()
  zscored[['mlbid']] <- this_df$mlbid

  for (i in this_stats) {

    for_zscoring <- data.frame(
      mlbid = this_df$mlbid,
      position = position_dummy,
      stat = this_df %>% magrittr::extract(i) %>% unname(),
      stringsAsFactors = FALSE
    )

    head(for_zscoring)

    zscore_df <- for_zscoring %>%
      dplyr::group_by(position) %>%
      dplyr::mutate(
        zscore = (stat - mean(stat)) / sd(stat)
      )

    zscored[[paste(i, 'zscore', sep = '_')]] <- zscore_df$zscore
  }

  dplyr::bind_rows(zscored)
}


