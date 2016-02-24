#' Scrape Fantasy Pros Projeections
#'
#' @inheritParams scrape_steamer
#' @return data frame with fantasy pros projection data
#' @export

scrape_fantasy_pros <- function(url) {

  h <- read_html(url)

  projs <- h %>%
    html_nodes('#data') %>%
    html_table()

  projs[[1]]
}



#' Read raw fantasy pros projections for a given year
#'
#' @inheritParams read_raw_steamer
#'
#' @return named list of data frames
#' @export

read_raw_fantasy_pros <- function(year) {

  urls <- list(
    'yr_2016_h' = 'http://www.fantasypros.com/mlb/projections/hitters.php',
    'yr_2016_p' = 'http://www.fantasypros.com/mlb/projections/pitchers.php'
  )

  h <- scrape_fantasy_pros(urls[[paste('yr', year, 'h', sep = '_')]])
  p <- scrape_fantasy_pros(urls[[paste('yr', year, 'p', sep = '_')]])

  list('h' = h, 'p' = p)
}


clean_raw_fantasy_pros <- function(df) {

  #clean player names
  player_names <- strsplit(df$Player, '(', fixed = TRUE)
  fullname <- lapply(player_names, function(x) extract(x, 1)) %>% unlist()
  df$FullName <- trim_whitespace(fullname)

  position <- lapply(player_names, function(x) extract(x, 2)) %>% unlist()
  team_position <- strsplit(position, ' - ', fixed = TRUE)
  df$team <- lapply(team_position, function(x) extract(x, 1)) %>% unlist()
  position_dirty <- lapply(team_position, function(x) extract(x, 2)) %>% unlist()
  df$position <- strsplit(position_dirty, ')', fixed = TRUE) %>%
    lapply(function(x) extract(x, 1)) %>% unlist()
  df$position <- clean_OF(df$position)

  df$FirstName <- split_firstlast(df$FullName)$first
  df$LastName <- split_firstlast(df$FullName)$last

  df <- df %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, user_settings$position_hierarchy)
    )

  #clean up df names
  names(df) <- tolower(names(df))

  df <- df %>%
    dplyr::select(-player)

  df
}

#' Get fantasy pros
#'
#' @description workhorse function.  reads the raw fantasy pros data file,
#' cleans up headers, returns projection prep object
#' @param year
#'
#' @return projection prep object
#' @export

get_fantasy_pros <- function(year) {

  raw <- read_raw_fantasy_pros(year)
  clean_h <- clean_raw_fantasy_pros(raw$h)
  clean_p <- clean_raw_fantasy_pros(raw$p)

  list('h' = clean_h, 'p' = clean_p)
}
