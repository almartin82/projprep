#' Scrape Fantasy Pros Projeections
#'
#' @inheritParams scrape_razzball_steamer
#' @return data frame with fantasy pros projection data
#'
#' @export

scrape_fantasy_pros <- function(url) {

  h <- xml2::read_html(url)

  projs <- h %>%
    html_nodes('#data') %>%
    html_table(fill = TRUE)

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
    'yr_2018_h' = 'http://www.fantasypros.com/mlb/projections/hitters.php',
    'yr_2018_p' = 'http://www.fantasypros.com/mlb/projections/pitchers.php'
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

  #get rid of two weird NA columns
  df <- df[, !is.na(names(df))]

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


#' Get fantasy pros
#'
#' @description workhorse function.  reads the raw fantasy pros dat,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @inheritParams get_razzball_steamer
#'
#' @return projection prep object
#' @export

get_fantasy_pros <- function(year, limit_unmatched = TRUE) {

  raw <- read_raw_fantasy_pros(year)
  clean_h <- clean_raw_fantasy_pros(raw$h, 'h')
  clean_p <- clean_raw_fantasy_pros(raw$p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    fantasy_pros_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the fp projections\n',
        num_h, num_p
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `fantasy_pros_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- 'fantasy_pros'
  clean_p$projection_name <- 'fantasy_pros'

  list('h' = clean_h, 'p' = clean_p)
}
