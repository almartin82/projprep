#' zscore
#'
#' @param proj_list named ('h', 'p') list of data frames, ie output of get_steamer
#' @param hit_pitch 'h' or 'p'
#' @param limit_player_pool zscores relative to all players, or relative size of drafted
#' player pool?
#'
#' @return list of data frames with stat zscores
#' @export

zscore <- function(
  proj_list,
  hit_pitch,
  limit_player_pool = TRUE
  ) {

  this_df <- proj_list %>% magrittr::extract2(hit_pitch)
  this_stats <- user_settings %>% magrittr::extract2(hit_pitch)

  zscored <- list()
  zscored[['mlbid']] <- this_df$mlbid

  for (i in this_stats) {

    for_zscoring <- data.frame(
      mlbid = this_df$mlbid,
      stat = this_df %>% magrittr::extract(i) %>% unname(),
      stringsAsFactors = FALSE
    )

    zscore_df <- for_zscoring %>%
      dplyr::mutate(
        zscore = (stat - mean(stat)) / sd(stat)
      )

    zscored[[paste(i, 'zscore', sep = '_')]] <- zscore_df$zscore
  }

  #sum
  zscored[['zscore_sum']] <- rowSums(
    zscored[names(zscored) != 'mlbid'] %>% dplyr::bind_rows()
  )

  out <- dplyr::bind_rows(zscored)

  if (limit_player_pool) {

    total_drafted <- user_settings$league_size * user_settings$roster_size
    roster_pct <- ifelse(
      hit_pitch == 'h', user_settings$h_roster_pct, 1 - user_settings$h_roster_pct
    )
    pool_limit <- ceiling(total_drafted * roster_pct)

    #cut by the top N
    zscored <- dplyr::bind_rows(zscored) %>%
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

    for (i in this_stats) {

      top_n_stat <- top_n %>% magrittr::extract(i) %>% unname() %>% unlist()

      for_zscoring <- data.frame(
        mlbid = this_df$mlbid,
        stat = this_df %>% magrittr::extract(i) %>% unname(),
        stringsAsFactors = FALSE
      )

      stat_zscored <- for_zscoring %>%
        dplyr::mutate(
          zscore = (stat - mean(top_n_stat)) / sd(top_n_stat)
        )

      zscored_limit[[paste(i, 'zscore', sep = '_')]] <- stat_zscored$zscore
    }

    farts <<- zscored_limit
    #sum
    zscored_limit[['zscore_sum']] <- rowSums(
      zscored_limit[names(zscored_limit) != 'mlbid'] %>% dplyr::bind_rows()
    )

    out <- dplyr::bind_rows(zscored_limit)
  }

  return(out)
}


