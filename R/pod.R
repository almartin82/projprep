#' Read raw pod projections, given a path to the download file
#'
#' @description reads the http://www.projectingx.com/baseball-player-projections/
#' pod projections.  pod projections are paid, so this function requires
#' a local path as the argument.
#' @param path_to_file local path to where the pod projections file is located.
#'
#' @return named list of data frames
#' @export

read_raw_pod <- function(path_to_file) {

  pod_h <- readxl::read_excel(path = path_to_file, sheet = 2)
  pod_p <- readxl::read_excel(path = path_to_file, sheet = 3)

  list('h' = pod_h, 'p' = pod_p)
}

#' Cleans up a pod projection file.
#'
#' @description names, consistent stat names, etc.
#' @param df raw pod df.  output of read_raw_pod
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_pod <- function(df, hit_pitch) {

  #names
  names(df) <- tolower(names(df))
  df$firstname <- split_firstlast(df$player)$first
  df$lastname <- split_firstlast(df$player)$last
  df$fullname <- paste(df$firstname, df$lastname)

  #fix stat names
  if (hit_pitch == 'h') {

    names(df)[names(df) == 'pos (20 g)'] <- 'position'
    df$position <- gsub('/', ', ', df$position, fixed = TRUE)

    #make tb
    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(hits, `2b`, `3b`, hr)
      )

  } else if (hit_pitch == 'p') {

    names(df)[names(df) == 'so'] <- 'k'

    #clean up stupid position names
    df$position <- df$role
    df$position <- gsub('S', 'SP', df$position)
    df$position <- gsub('Cl', 'RP', df$position)
    df$position <- gsub('MR', 'RP', df$position)

  }

  df
}


#' Get pod projections
#'
#' @description workhorse function.  reads the raw pod excel file,
#' cleans up headers, returns list of projection data frames ready for
#' projection_prep function.
#'
#' @param path_to_file path to the pod excel file you downloaded
#' (pod projections are paid).
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

get_pod <- function(path_to_file, limit_unmatched = TRUE) {

  raw <- read_raw_pod(path_to_file)
  clean_h <- clean_raw_pod(raw$h, 'h')
  clean_p <- clean_raw_pod(raw$p, 'p')

  clean_h$mlbid <- mlbid_match(clean_h)
  clean_p$mlbid <- mlbid_match(clean_p)

  if (limit_unmatched) {
    num_h <- sum(is.na(clean_h$mlbid))
    num_p <- sum(is.na(clean_p$mlbid))

    pod_unmatched <<- c(
      clean_h[is.na(clean_h$mlbid), ]$fullname,
      clean_p[is.na(clean_p$mlbid), ]$fullname
    )

    message(paste0(
      sprintf(
        'dropped %s hitters and %s pitchers from the pod projections\n',
        num_h, num_p
      ),
      'data because ids could not be matched.  these are usually players\n',
      'with limited AB/IP.  see `pod_unmatched` for names.'
    ))

    clean_h <- clean_h[!is.na(clean_h$mlbid), ]
    clean_p <- clean_p[!is.na(clean_p$mlbid), ]
  }

  #force one row per player
  clean_h <- force_h_unique(clean_h)
  clean_p <- force_p_unique(clean_p)

  clean_h$projection_name <- 'pod'
  clean_p$projection_name <- 'pod'

  list('h' = clean_h, 'p' = clean_p)
}
