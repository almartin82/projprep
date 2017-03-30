#' generic fangraphs scrape
#'
#' @description pulls down fangraphs projections, given a projection
#' system and hit/pitch value
#' @param bat_pitch either 'bat' or 'pit'
#' @param proj_system name of a projection system.  one of c('zips',
#' 'steamer', 'steamer600', 'fangraphsdc')
#'
#' @return data frame
#' @export

scrape_fangraphs <- function(bat_pitch, proj_system) {

  base_fangraphs <- 'http://www.fangraphs.com/projections.aspx?pos='
  if (bat_pitch == 'bat') {
    end_params <- '&players=0&sort=4,d'
    pos_choices <- c('c', '1b', '2b', 'ss', '3b', 'of')
  } else if (bat_pitch == 'pit') {
    end_params <- '&players=0&sort=9,d'
    pos_choices <- c('all')
  }

  url1 <- paste0(base_fangraphs, pos_choices)
  url_params <- sprintf('&stats=%s&type=%s&team=', bat_pitch, proj_system)
  url2 <- paste0(url1, url_params)
  url3 <- expand.grid(url2, c(1:30))
  urls <- paste0(url3$Var1, url3$Var2, end_params)

  proj_list <- lapply(urls, function(x){
      team_table <- XML::readHTMLTable(
        x, as.data.frame = TRUE, stringsAsFactors = FALSE
      )
      df <- team_table$ProjectionBoard1_dg1_ctl00
      df$url <- x

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


#' Cleans up a fangraphs (steamer, zips etc) projection file.
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

  #drop the weird notes column
  names(df)[2] <- 'fg_note'
  df <- df %>%
    dplyr::select(-fg_note)

  #clean up player names
  names(df)[names(df) == 'name'] <- 'fullname'
  df$firstname <- split_firstlast(df$fullname)$first
  df$lastname <- split_firstlast(df$fullname)$last

  if (hit_pitch == 'h') {

    #get positions from the url string
    pos <- stringr::str_extract(df$url, "pos=\\w{1,2}")
    pos <- gsub('pos=', '', pos) %>% toupper()
    df$position <- pos

    df <- force_numeric(
      df, c("pa", "ab", "h", "2b", "3b", "hr", "r", "rbi", "bb",
            "so", "hbp", "sb", "cs", "avg", "obp", "slg", "ops",
            "woba", "wrc+", "bsr", "fld", "off", "def", "war")
    )

    #tb
    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(h, `2b`, `3b`, hr)
      )

    #group_concat positions
    pos_df <- df %>%
      dplyr::select(
        fullname, team, position
      ) %>%
      dplyr::ungroup() %>%
      dplyr::group_by(fullname, team) %>%
      dplyr::summarize(
        position = toString(unique(position))
      )

    stat_df <- df %>%
      dplyr::select(-url, -position) %>%
      unique()

    df <- pos_df %>%
      dplyr::inner_join(
        y = stat_df,
        by = c('fullname', 'team')
      )

  } else if (hit_pitch == 'p') {

    df <- force_numeric(
      df, c('w', 'l', 'era', 'gs', 'g', 'sv', 'ip', 'h', 'er', 'hr',
            'so', 'bb', 'whip', 'k/9', 'bb/9', 'fip', 'war', 'ra9-war')
    )

    df$position <- ifelse(df$gs >= 2, 'SP', 'RP')
    names(df)[names(df) == 'so'] <- 'k'

    df <- df %>%
      dplyr::select(-url)
  }

  df
}


#' Get various fangraphs projections
#'
#' @description workhorse function.  reads, cleans, preps, matches
#' fangraphs projections
#' @param year desired year.  valid values: 2016
#' @param proj_system proj_system name of a projection system.  one of c('zips',
#' 'steamer', 'steamer600', 'fangraphsdc')
#' @param limit_unmatched if TRUE (the default behavior) will only
#' return players with an mlbid that can be matched.  look at `id_map`
#' and the `universal_metadata` vignette for more about the id map
#' we're using to match players to ids.
#' fundamentally, you need a consistent, unique identifier if you
#' want to work with multiple projection systems.  so this really
#' needs to be TRUE.
#'
#' @return list of named projection data frames.
#' @export

get_fangraphs <- function(year, proj_system, limit_unmatched = TRUE) {
  year %>% ensurer::ensure_that(
      . == 2017 ~ 'fangraphs only reports current-year projections.'
    )

  raw_h <- scrape_fangraphs('bat', proj_system)
  raw_p <- scrape_fangraphs('pit', proj_system)

  clean_h <- clean_raw_fangraphs(raw_h, 'h')
  clean_p <- clean_raw_fangraphs(raw_p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    fangraphs_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the %s projections\n',
        num_h, num_p, proj_system
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `fangraphs_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #zips doesn't project saves.  set to NA
  if (proj_system == 'zips') {
    clean_p$sv <- NA
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- proj_system
  clean_p$projection_name <- proj_system

  list('h' = clean_h, 'p' = clean_p)
}


#' Get steamer projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_steamer <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'steamer', limit_unmatched)
}


#' Get steamer projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_steamer <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'steamer', limit_unmatched)
}


#' Get steamer600 projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_steamer600 <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'steamer600', limit_unmatched)
}


#' Get steamer600 projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_steamer600 <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'steamer600', limit_unmatched)
}


#' Get fangraphs depth charts projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_fangraphs_depth_charts <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'fangraphsdc', limit_unmatched)
}


#' Get zips projections
#'
#' @description see ?get_fangraphs
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_zips <- function(year, limit_unmatched = TRUE) {
  get_fangraphs(year, 'zips', limit_unmatched)
}
