#' Read raw guru projections for a given year
#'
#' @inheritParams read_raw_steamer
#'
#' @return named list of data frames
#' @export

read_raw_guru <- function(year) {

  urls <- list(
    '2016' = 'http://baseballguru.com/GURU_mForecast2016.xls'
  )

  url <- urls[[as.character(year)]]

  tname <- tempfile(pattern = 'guru', tmpdir = tempdir(), fileext = '.xls')
  downloader::download(url, destfile = tname, mode = 'wb')
  guru_p <- readxl::read_excel(path = tname, sheet = 3, skip = 1)
  guru_h <- readxl::read_excel(path = tname, sheet = 4, skip = 1)

  list('h' = guru_h, 'p' = guru_p)
}


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
    hierarchy <- user_settings$h_hierarchy

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

    hierarchy <- user_settings$p_hierarchy

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

  #priority pos
  df <- df %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, hierarchy)
    )

  #DH to util if util
  if ('Util' %in% names(user_settings$special_positions$h)) {
    df$priority_pos <- gsub('DH', 'Util', df$priority_pos)
  }


  df
}



guru_mlbid_match <- function(guru_df, mlbid = NA) {
  #just a stub for now
  guru_df$mlbid <- c(1:nrow(guru_df))

  guru_df
}



#' Get guru projections
#'
#' @description workhorse function.  reads the raw guru excel file,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#' @inheritParams read_raw_steamer
#' @return list of named projection data frames.
#' @export

get_guru <- function(year) {

  raw <- read_raw_guru(year)
  clean_h <- clean_raw_guru(raw$h, 'h')
  clean_p <- clean_raw_guru(raw$p, 'p')

  clean_h <- guru_mlbid_match(clean_h)
  clean_p <- guru_mlbid_match(clean_p)

  clean_h$projection_name <- 'guru'
  clean_p$projection_name <- 'guru'

  list('h' = clean_h, 'p' = clean_p)
}
