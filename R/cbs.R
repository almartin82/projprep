#' Scrape CBS Projeections
#'
#' @inheritParams scrape_razzball_steamer
#' @param pos position name
#' @return data frame with fantasy pros projection data
#'
#' @export

scrape_cbs <- function(url, pos) {

  cbs_url <- sprintf(url, pos)
  h <- read_html(cbs_url)

  projs <- h %>%
    html_nodes('#layoutRailNone') %>%
    html_nodes('.data') %>%
    html_table(fill = TRUE) %>%
    magrittr::extract2(1)

  #projection names are in the 2nd row
  proj_names <- projs[2, 1:(ncol(projs)-1)]
  #trim bad rows from bottom, top and right
  proj_clean <- projs[3:(nrow(projs) - 1), 1:(ncol(projs)-1)]
  names(proj_clean) <- proj_names

  proj_clean$position <- pos
  proj_clean
}




#' Read raw cbs projections for a given year
#'
#' @inheritParams read_raw_razzball_steamer
#'
#' @return named list of data frames
#' @export

read_raw_cbs <- function(year) {

  urls <- list(
    '2016' = 'http://www.cbssports.com/fantasy/baseball/stats/sortable/cbs/%s/season/standard/projections?&print_rows=9999'
  )

  url <- urls[[as.character(year)]]

  cbs_h <- list()
  cbs_h[['hc']] <- scrape_cbs(url, 'C')
  cbs_h[['h1b']] <- scrape_cbs(url, '1B')
  cbs_h[['h2b']] <- scrape_cbs(url, '2B')
  cbs_h[['hss']] <- scrape_cbs(url, 'SS')
  cbs_h[['h3b']] <- scrape_cbs(url, '3B')
  cbs_h[['hof']] <- scrape_cbs(url, 'OF')
  cbs_h[['hdf']] <- scrape_cbs(url, 'DH')
  h <- dplyr::bind_rows(cbs_h)

  cbs_p <- list()
  cbs_p[['sp']] <- scrape_cbs(url, 'SP')
  cbs_p[['rp']] <- scrape_cbs(url, 'RP')
  p <- dplyr::bind_rows(cbs_p)

  list('h' = h, 'p' = p)
}


#' Cleans up a cbs projection scrape
#'
#' @description names, consistent stat names, etc.
#' @param df raw cbs df.  output of read_raw_cbs.
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_cbs <- function(df, hit_pitch) {

  names(df) <- tolower(names(df))

  #clean player names
  player_names <- strsplit(df$player, ',', fixed = TRUE)
  fullname <- lapply(player_names, function(x) extract(x, 1)) %>% unlist()
  df$fullname <- trim_whitespace(fullname)
  df$firstname <- split_firstlast(df$fullname)$first
  df$lastname <- split_firstlast(df$fullname)$last

  #build tb
  if (hit_pitch == 'h') {
    #string to numeric
    df <- force_numeric(
      df, c('ab', 'r', 'h', '1b', '2b', '3b', 'hr', 'rbi', 'bb', 'ko',
            'sb', 'cs', 'ba', 'obp', 'slg')
    )

    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(h, `2b`, `3b`, hr)
      )
  } else if (hit_pitch == 'p') {

    names(df)[names(df) == 's'] <- 'sv'
    names(df)[names(df) == 'inn'] <- 'ip'

    df <- force_numeric(
      df, c("ip", "gs", "qs", "cg", "w", "l", "sv", "bs", "k",
            "bbi", "ha", "era", "whip")
    )
  }

  #drop unwanted columns
  df <- df %>%
    dplyr::select(-player, -fpts)

  df
}


cbs_mlbid_match <- function(cbs_df, mlbid = NA) {
  #just a stub for now
  cbs_df$mlbid <- c(1:nrow(cbs_df))

  cbs_df
}


#' Get cbs
#'
#' @description workhorse function.  reads the raw cbs data file,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @inheritParams read_raw_razzball_steamer
#' @return list of named projection data frames.
#' @export

get_cbs <- function(year) {

  raw <- read_raw_cbs(year)
  clean_h <- clean_raw_cbs(raw$h, 'h')
  clean_p <- clean_raw_cbs(raw$p, 'p')

  clean_h <- cbs_mlbid_match(clean_h)
  clean_p <- cbs_mlbid_match(clean_p)

  clean_h$projection_name <- 'cbs'
  clean_p$projection_name <- 'cbs'

  proj_list <- list('h' = clean_h, 'p' = clean_p)

  proj_list
}
