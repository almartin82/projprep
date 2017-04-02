#' Read raw guru projections for a given year
#'
#' @inheritParams read_raw_razzball_steamer
#'
#' @return named list of data frames
#' @export

read_raw_guru <- function(year) {

  urls <- list(
    '2016' = 'http://baseballguru.com/GURU_mForecast2016.xls',
    '2017' = 'http://baseballguru.com/GURU_mForecast2017.xls'
  )

  url <- urls[[as.character(year)]]

  tname <- tempfile(pattern = 'guru', tmpdir = tempdir(), fileext = '.xls')
  downloader::download(url, destfile = tname, mode = 'wb')
  guru_p <- readxl::read_excel(path = tname, sheet = 3, skip = 1)
  guru_h <- readxl::read_excel(path = tname, sheet = 4, skip = 1)

  list('h' = guru_h, 'p' = guru_p)
}


#' Cleans up a guru projection file.
#'
#' @description names, consistent stat names, etc.
#' @param df raw guru df.  output of read_raw_guru
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_guru <- function(df, hit_pitch) {

  #names
  names(df) <- tolower(names(df))
  names(df)[names(df) == 'namelast'] <- 'lastname'
  names(df)[names(df) == 'namefirst'] <- 'firstname'
  df$fullname = paste(df$firstname, df$lastname)

  #dead rows at the end
  df <- df[!is.na(df$reliability), ]

  #fix stat names
  if (hit_pitch == 'h') {
    #players with no games
    df <- df[df$mg > 0, ]

    #stat names
    names(df)[13:40] <- gsub('^[m]', '', names(df)[13:40])
    names(df)[names(df) == 'db'] <- '2b'
    names(df)[names(df) == 'tr'] <- '3b'

    #build tb
    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(h, `2b`, `3b`, hr)
      )

    df$position <- paste(df$pos, df$pos2, df$pos3, sep = ', ') %>%
      gsub(', NA', '', .)

    df <- df %>%
      select(-pos, -pos2, -pos3)

  } else if (hit_pitch == 'p') {

    #players with no ip
    df <- df[df$mip > 0, ]
    df <- df[!is.na(df$mdera), ]

    #stat names
    names(df)[11:57] <- gsub('^[m]', '', names(df)[11:57])
    names(df)[names(df) == 'soa'] <- 'k'
    names(df)[names(df) == 'dera'] <- 'era'
    names(df)[names(df) == 'pos'] <- 'position'

    #clean up stupid position names
    df$position <- gsub('LP', 'RP', df$position)
    df$position <- gsub('JP', 'SP', df$position)
    df$position <- gsub('EP', 'RP', df$position)
    df$position <- gsub('DP', 'RP', df$position)
    df$position <- gsub('BP', 'RP', df$position)
    df$position <- gsub('AP', 'RP', df$position)
  }

  df
}


#' Get guru projections
#'
#' @description workhorse function.  reads the raw guru excel file,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @inheritParams get_razzball_steamer
#'
#' @return list of named projection data frames.
#' @export

get_guru <- function(year, limit_unmatched = TRUE) {

  raw <- read_raw_guru(year)
  clean_h <- clean_raw_guru(raw$h, 'h')
  clean_p <- clean_raw_guru(raw$p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    guru_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the guru projections\n',
        num_h, num_p
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `guru_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- 'guru'
  clean_p$projection_name <- 'guru'

  list('h' = clean_h, 'p' = clean_p)
}
