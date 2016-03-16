#' Read raw pecota projections, given a path to the download file
#'
#' @description reads the BP PECOTA projections.
#' these are paid projections, so this function requires
#' a local path as the argument.
#' @inheritParams read_raw_pod
#'
#' @return named list of data frames
#' @export

read_raw_pecota <- function(path_to_file) {

  pecota_h <- readxl::read_excel(
    path = path_to_file, sheet = 2
  )
  pecota_p <- readxl::read_excel(
    path = path_to_file, sheet = 3
  )

  list('h' = pecota_h, 'p' = pecota_p)
}


clean_raw_pecota <- function(df, hit_pitch) {

  #names
  names(df) <- tolower(names(df))
  df$fullname <- paste(df$firstname, df$lastname)
  names(df)[names(df) == 'pos'] <- 'position'

  #clean stats
  if (hit_pitch == 'h') {
    names(df)[names(df) == 'pos'] <- 'position'
    df$position <- clean_OF(df$position)
    df$position <- trim_whitespace(df$position)

  } else if (hit_pitch == 'p') {
    names(df)[names(df) == 'so'] <- 'k'
    df$position <- ifelse(df$gs >= 2, 'SP', 'RP')
  }

  df
}


#' Get pecota projections
#'
#' @description workhorse function.  reads the raw pecota excel file,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#'
#' @param path_to_file path to the pecota excel file you downloaded
#' (pecota projections are paid).
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

get_pecota <- function(path_to_file, limit_unmatched = TRUE) {

  raw <- read_raw_pecota(path_to_file)
  clean_h <- clean_raw_pecota(raw$h, 'h')
  clean_p <- clean_raw_pecota(raw$p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    pecota_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the pecota projections\n',
        num_h, num_p
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `pecota_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- 'pecota'
  clean_p$projection_name <- 'pecota'

  print(names(clean_p))

  list('h' = clean_h, 'p' = clean_p)
}

