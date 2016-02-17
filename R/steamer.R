#' Scrape Steamer Projections
#'
#' @param url html table with steamer projections
#'
#' @return a data frame with projections
#' @export

scrape_steamer <- function(url) {

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
#' @return list of data frames
#' @export

read_raw_steamer <- function(year) {

  urls <- list(
    'yr_2016_h' = 'http://razzball.com/steamer-hitter-projections/',
    'yr_2016_p' = 'http://razzball.com/steamer-pitcher-projections/'
  )

  h <- scrape_steamer(urls[[paste('yr', year, 'h', sep = '_')]])
  p <- scrape_steamer(urls[[paste('yr', year, 'p', sep = '_')]])

  list('h' = h, 'p' = p)
}


#' Cleans up a steamer projection file.
#'
#' @description names, consistent stat names, etc.
#' @param df raw steamer df.  output of read_raw_steamer.
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_steamer <- function(df) {

  #clean up player names
  names(df)[names(df) == 'Name'] <- 'FullName'
  df$FirstName <- split_name(df$FullName)$first
  df$LastName <- split_name(df$FullName)$last

  #clean up df names
  names(df) <- tolower(names(df))

  #clean up positions
  if (user_settings$site == 'yahoo') {
    df$position <- df$yahoo
  } else if (user_settings$site == 'espn') {
    df$position <- df$espn
  }

  #drop unwanted
  mask <- names(df) %in% c('#', 'espn', 'yahoo')

  #return
  df[, !mask]
}



steamer_mlbid_match <- function(steamer_df, mlbid = NA) {
  #just a stub for now
  steamer_df$mlbid <- NA

  steamer_df
}


#' Get steamer projections
#'
#' @description workhorse function.  reads the raw steamer data file,
#' cleans up headers, returns consistent df
#' @inheritParams read_raw_steamer
#' @return a projection prep object.
#' @export

get_steamer <- function(year) {

  raw <- read_raw_steamer(year)
  clean_h <- clean_raw_steamer(raw$h)
  clean_p <- clean_raw_steamer(raw$p)

  clean_h <- steamer_mlbid_match(clean_h)
  clean_p <- steamer_mlbid_match(clean_p)

  list('h' = clean_h, 'p' = clean_p)
}
