#' Scrape Steamer Projections
#'
#' @param url html table with steamer projections
#'
#' @return data frame with steamer projection data
#' @export

scrape_razzball_steamer <- function(url) {

  h <- read_html(url)

  h_stats <- h %>%
    html_nodes(xpath='//*[@id="neorazzstatstable"]') %>%
    html_table()

  h_stats[[1]]
}


#' Read raw steamer projections in for a given year
#'
#' @description this function will handle any logic for changing urls, etc.
#' the goal is to create a consistentcy in the R calls, so that whatever
#' work that needs to get done in locating data year over year is handled
#' by the functions and not exposed to the end user.
#'
#' @param year desired year.  valid values: 2016
#'
#' @return named list of data frames
#' @export

read_raw_razzball_steamer <- function(year) {

  urls <- list(
    'yr_2016_h' = 'http://razzball.com/steamer-hitter-projections/',
    'yr_2016_p' = 'http://razzball.com/steamer-pitcher-projections/'
  )

  h <- scrape_razzball_steamer(urls[[paste('yr', year, 'h', sep = '_')]])
  p <- scrape_razzball_steamer(urls[[paste('yr', year, 'p', sep = '_')]])

  list('h' = h, 'p' = p)
}


#' Cleans up a steamer projection file.
#'
#' @description names, consistent stat names, etc.
#' @param df raw steamer df.  output of read_raw_razzball_steamer.
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_razzball_steamer <- function(df, hit_pitch) {

  #clean up player names
  names(df)[names(df) == 'Name'] <- 'FullName'
  #no idea what these weird characters are
  df$FullName <- gsub('[/pla', '', df$FullName, fixed = TRUE)
  df$FirstName <- split_firstlast(df$FullName)$first
  df$LastName <- split_firstlast(df$FullName)$last

  #clean up df names
  names(df) <- tolower(names(df))
  names(df)[names(df) == 'pos'] <- 'position'

  #clean up positions
  if (user_settings$site == 'yahoo' & 'yahoo' %in% names(df)) {
    df$position <- df$yahoo
  } else if (user_settings$site == 'espn' & 'espn' %in% names(df)) {
    df$position <- df$espn
  }

  #priority_position
  if (hit_pitch == 'h') {
    hierarchy <- user_settings$h_hierarchy
  } else if (hit_pitch == 'p') {
    hierarchy <- user_settings$p_hierarchy
  }
  df <- df %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, hierarchy)
    )

  #DH to util if util
  if ('Util' %in% names(user_settings$special_positions$h)) {
    df$priority_pos <- gsub('DH', 'Util', df$priority_pos)
  }

  #drop unwanted
  mask <- names(df) %in% c('#', 'espn', 'yahoo')

  #return
  df[, !mask]
}


#' Get steamer projections
#'
#' @description workhorse function.  reads the raw steamer data,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @inheritParams read_raw_razzball_steamer
#' @param limit_unmatched if TRUE (the default behavior) will only
#' return players with an mlbid that can be matched.  look at `id_map`
#' and the `universal_metadata` vignette for more about the id map
#' we're using to match players to ids.
#' fundamentally, you need a consistent, unique identifier if you
#' want to work with multiple projection systems.  so this really
#' needs to be TRUE.
#' @return list of named projection data frames.
#' @export

get_razzball_steamer <- function(year, limit_unmatched = TRUE) {

  raw <- read_raw_razzball_steamer(year)
  clean_h <- clean_raw_razzball_steamer(raw$h, 'h')
  clean_p <- clean_raw_razzball_steamer(raw$p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    razzball_steamer_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the razzball steamer\n',
        num_h, num_p
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `razzball_steamer_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- 'steamer'
  clean_p$projection_name <- 'steamer'

  list('h' = clean_h, 'p' = clean_p)
}
