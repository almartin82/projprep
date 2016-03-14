
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


#' fangraphs fans scrape
#'
#' @return data frame
#' @export

read_raw_fangraphs_fans <- function() {

  h <- scrape_fangraphs('bat', 'fan')
  p <- scrape_fangraphs('pit', 'fan')

  list('h' = h, 'p' = p)
}
