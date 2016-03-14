#' generic fangraphs scrape
#'
#' @description pulls down fangraphs projections, given a projection
#' system and hit/pitch value
#' @param bat_pitch either 'bat' or 'pit'
#' @param proj_system name of a projection system.  one of c('zips',
#' 'fan', 'steamer', 'steamer600', 'fangraphsdc')
#'
#' @return data frame
#' @export

scrape_fangraphs <- function(bat_pitch, proj_system) {

  base_fangraphs <- 'http://www.fangraphs.com/projections.aspx?'
  url_params <- sprintf('pos=all&stats=%s&type=%s&team=', bat_pitch, proj_system)
  if (bat_pitch == 'bat') {
    end_params <- '&players=0&sort=26,d'
  } else if (bat_pitch == 'pit') {
    end_params <- '&players=0&sort=9,d'
  }
  urls <- paste0(
    base_fangraphs, url_params, c(1:30), end_params
  )

  proj_list <- lapply(urls, function(x){
      team_table <- XML::readHTMLTable(
        x, as.data.frame = TRUE, stringsAsFactors = FALSE
      )
      df <- team_table$ProjectionBoard1_dg1_ctl00

      df
    }
  )

  out <- dplyr::bind_rows(proj_list)
  out
}


#' steamer scrape
#'
#' @return data frame
#' @export

read_raw_steamer <- function() {

  h <- scrape_fangraphs('bat', 'steamer')
  p <- scrape_fangraphs('pit', 'steamer')

  list('h' = h, 'p' = p)
}


#' steamer600 scrape
#'
#' @return data frame
#' @export

read_raw_steamer600 <- function() {

  h <- scrape_fangraphs('bat', 'steamer600')
  p <- scrape_fangraphs('pit', 'steamer600')

  list('h' = h, 'p' = p)
}


#' fangraphs fans scrape
#'
#' @return data frame
#' @export

read_raw_fangraphs_fans <- function() {

  h <- scrape_fangraphs('bat', 'fan')
  p <- scrape_fangraphs('pit', 'fan')

  list('h' = h, 'p' = p)
}


#' zips scrape
#'
#' @return data frame
#' @export

read_raw_zips <- function() {

  h <- scrape_fangraphs('bat', 'zips')
  p <- scrape_fangraphs('pit', 'zips')

  list('h' = h, 'p' = p)
}


#' zips scrape
#'
#' @return data frame
#' @export

read_raw_zips <- function() {

  h <- scrape_fangraphs('bat', 'fangraphsdc')
  p <- scrape_fangraphs('pit', 'fangraphsdc')

  list('h' = h, 'p' = p)
}


#' Cleans up a fangraphs (steamer, zips, fans etc) projection file.
#'
#' @description names, consistent stat names, etc.
#' @param df raw fangraphs df, eg output of read_raw_steamer
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_fangraphs <- function(df, hit_pitch) {

  #clean up df names
  names(df) <- tolower(names(df))
  names(df)[names(df) == 'pos'] <- 'position'

  #clean up player names
  names(df)[names(df) == 'Name'] <- 'FullName'
  #no idea what these weird characters are
  df$FullName <- gsub('[/pla', '', df$FullName, fixed = TRUE)
  df$FirstName <- split_firstlast(df$FullName)$first
  df$LastName <- split_firstlast(df$FullName)$last



}
