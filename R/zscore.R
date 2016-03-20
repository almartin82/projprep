#' zscore
#'
#' @param proj_list named ('h', 'p') list of data frames, ie output of get_steamer
#' @param hit_pitch 'h' or 'p'
#' @param stat_direction vector that flags if the stat is
#' reverse-framed (lower = better).  default behavior is
#' to read from user_settings.
#' @param is_rate vector that flags if the state is a rate stat.
#' default behavior is to read from user_settings.
#' @param limit_player_pool zscores relative to all players, or relative size of drafted
#' player pool?
#'
#' @return list of data frames with stat zscores
#' @export

zscore <- function(
  proj_list,
  hit_pitch,
  stat_direction = user_settings %>%
    magrittr::extract2(paste0(hit_pitch, '_higher_better')),
  is_rate = user_settings %>%
    magrittr::extract2(paste0(hit_pitch, '_rate')),
  limit_player_pool = TRUE
  ) {

  this_df <- proj_list %>% magrittr::extract2(hit_pitch)
  this_stats <- user_settings %>% magrittr::extract2(hit_pitch)

  zscored <- list()
  zscored[['mlbid']] <- this_df$mlbid

  for (i in seq_along(this_stats)) {

    stat <- this_stats[i]
    stat_dir <- ifelse(stat_direction[i], 1, -1)
    stat_rate <- is_rate[i]

    for_zscoring <- data.frame(
      mlbid = this_df$mlbid,
      stat = this_df %>%
        magrittr::extract(stat) %>%
        unname(),
      stringsAsFactors = FALSE
    )

    #convert rate to count
    if (stat_rate & hit_pitch == 'h') {
      for_zscoring$stat <- this_df$ab * for_zscoring$stat
    }
    if (stat_rate & hit_pitch == 'p') {
      for_zscoring$stat <- this_df$ip * for_zscoring$stat
    }

    zscore_df <- for_zscoring %>%
      dplyr::mutate(
        zscore = (stat - mean(stat)) / sd(stat)
      )
    #handle missing stats
    zscore_df$zscore <- ifelse(is.nan(zscore_df$zscore), 0, zscore_df$zscore)
    zscore_df$zscore <- ifelse(is.na(zscore_df$zscore), 0, zscore_df$zscore)

    zscore_df$zscore <- zscore_df$zscore * stat_dir
    zscored[[paste(stat, 'zscore', sep = '_')]] <- zscore_df$zscore
  }

  #sum
  zscore_cols <- zscored[names(zscored) != 'mlbid']
  zscored[['zscore_sum']] <- rowSums(
    dplyr::rbind_list(zscore_cols)
  )

  out <- dplyr::rbind_list(zscored)

  if (limit_player_pool) {

    total_drafted <- user_settings$league_size * user_settings$roster_size
    roster_pct <- ifelse(
      hit_pitch == 'h', user_settings$h_roster_pct, 1 - user_settings$h_roster_pct
    )
    pool_limit <- ceiling(total_drafted * roster_pct)

    #cut by the top N
    zscored <- dplyr::rbind_list(zscored) %>%
      dplyr::mutate(
        ranking = rank(desc(zscore_sum), ties.method = 'first')
      )

    #go back to orig stats
    master_zscoring <- this_df %>%
      left_join(zscored[, c('mlbid', 'ranking')], by = 'mlbid')

    #limit to top N players, then loop over each stat and zscore
    top_n <- master_zscoring %>%
      dplyr::filter(
        ranking <= pool_limit
      )

    #lists to hold stats
    zscored_limit <- list()
    zscored_limit[['mlbid']] <- this_df$mlbid

    for (i in seq_along(this_stats)) {

      stat <- this_stats[i]
      stat_dir <- ifelse(stat_direction[i], 1, -1)
      stat_rate <- is_rate[i]

      top_n$stat <- top_n %>% magrittr::extract(stat)

      for_zscoring <- data.frame(
        mlbid = this_df$mlbid,
        stat = this_df %>% magrittr::extract(stat) %>% unname(),
        stringsAsFactors = FALSE
      )

      #convert rate to count
      if (stat_rate & hit_pitch == 'h') {
        top_n$stat <- top_n$ab * top_n$stat
        for_zscoring$stat <- this_df$ab * for_zscoring$stat
      }
      if (stat_rate & hit_pitch == 'p') {
        top_n$stat <- top_n$ip * top_n$stat
        for_zscoring$stat <- this_df$ip * for_zscoring$stat
      }

      top_n_stat <- top_n$stat %>% unname() %>% unlist()

      stat_zscored <- for_zscoring %>%
        dplyr::mutate(
          zscore = (stat - mean(top_n_stat)) / sd(top_n_stat)
        )
      #handle missing stats
      stat_zscored$zscore <- ifelse(
        is.nan(stat_zscored$zscore), 0, stat_zscored$zscore
      )
      stat_zscored$zscore <- ifelse(
        is.na(stat_zscored$zscore), 0, stat_zscored$zscore
      )
      stat_zscored$zscore <- stat_zscored$zscore * stat_dir
      zscored_limit[[paste(stat, 'zscore', sep = '_')]] <- stat_zscored$zscore
    }

    #sum
    zscored_limit[['zscore_sum']] <- rowSums(
      zscored_limit[names(zscored_limit) != 'mlbid'] %>% dplyr::rbind_list()
    )

    out <- dplyr::rbind_list(zscored_limit)
  }

  return(out)
}
