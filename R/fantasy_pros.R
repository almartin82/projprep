#' Scrape Fantasy Pros Projeections
#'
#' @inheritParams scrape_razzball_steamer
#' @return data frame with fantasy pros projection data
#'
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
#' @inheritParams read_raw_razzball_steamer
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


#' Cleans up a fantasy pros projection scrape
#'
#' @description names, consistent stat names, etc.
#' @param df raw fantasy pros df.  output of read_raw_fantasy_pros.
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_fantasy_pros <- function(df, hit_pitch) {

  #clean player names
  player_names <- strsplit(df$Player, '(', fixed = TRUE)
  fullname <- lapply(player_names, function(x) extract(x, 1)) %>% unlist()
  df$FullName <- trim_whitespace(fullname)
  df$FirstName <- split_firstlast(df$FullName)$first
  df$LastName <- split_firstlast(df$FullName)$last

  #get positions from messy character string
  position <- lapply(player_names, function(x) extract(x, 2)) %>% unlist()
  position <- ifelse(
    !grepl('-', position, fixed = TRUE), paste0('None - ', position), position
  )
  team_position <- strsplit(position, ' - ')

  df$team <- lapply(team_position, function(x) extract(x, 1)) %>% unlist()
  position_dirty <- lapply(team_position, function(x) extract(x, 2)) %>% unlist()
  df$position <- strsplit(position_dirty, ')', fixed = TRUE) %>%
    lapply(function(x) extract(x, 1)) %>% unlist()
  df$position <- clean_OF(df$position)
  df$position <- clean_pos(df$position)
  df$position <- clean_p(df$position)
  #get priority position
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

  #clean up df names
  names(df) <- tolower(names(df))

  #build tb
  if (hit_pitch == 'h') {
    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(h, `2b`, `3b`, hr)
      )
  }

  #drop unwanted columns
  df <- df %>%
    dplyr::select(-player)

  df
}


fantasy_pros_mlbid_match <- function(fantasy_pros_df, mlbid = NA) {
  #just a stub for now
  fantasy_pros_df$mlbid <- c(1:nrow(fantasy_pros_df))

  fantasy_pros_df
}


#' Get fantasy pros
#'
#' @description workhorse function.  reads the raw fantasy pros dat,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @param year
#'
#' @return projection prep object
#' @export

get_fantasy_pros <- function(year) {

  raw <- read_raw_fantasy_pros(year)
  clean_h <- clean_raw_fantasy_pros(raw$h, 'h')
  clean_p <- clean_raw_fantasy_pros(raw$p, 'p')

  clean_h <- fantasy_pros_mlbid_match(clean_h)
  clean_p <- fantasy_pros_mlbid_match(clean_p)

  clean_h$projection_name <- 'fantasy_pros'
  clean_p$projection_name <- 'fantasy_pros'

  list('h' = clean_h, 'p' = clean_p)
}
