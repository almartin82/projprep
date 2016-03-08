#' Scrape CBS Projeections
#'
#' @inheritParams scrape_steamer
#' @param pos position name
#' @return data frame with fantasy pros projection data
#'
#' @export

scrape_cbs_h <- function(url, pos) {

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
#' @inheritParams read_raw_steamer
#'
#' @return named list of data frames
#' @export

read_raw_cbs <- function(year) {

  urls <- list(
    '2016' = 'http://www.cbssports.com/fantasy/baseball/stats/sortable/cbs/%s/season/standard/projections'
  )

  url <- urls[[as.character(year)]]

  cbs_h <- list()
  cbs_h[['hc']] <- scrape_cbs_h(url, 'C')
  cbs_h[['h1b']] <- scrape_cbs_h(url, '1B')
  cbs_h[['h2b']] <- scrape_cbs_h(url, '2B')
  cbs_h[['hss']] <- scrape_cbs_h(url, 'SS')
  cbs_h[['h3b']] <- scrape_cbs_h(url, '3B')
  cbs_h[['hof']] <- scrape_cbs_h(url, 'OF')
  cbs_h[['hdf']] <- scrape_cbs_h(url, 'DH')

  h <- dplyr::bind_rows(cbs_h)

  list('h' = h)
}
