#' Read raw guru projections, given a path to the download file
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
#' @param df raw steamer df.  output of read_raw_pod
#' @param hit_pitch c('h', 'p')
#'
#' @return a data frame with consistent variable names
#' @export

clean_raw_pod <- function(df, hit_pitch) {

  #names
  names(df) <- tolower(names(df))
  df$firstname <- split_firstlast(df$player)$first
  df$lastname <- split_firstlast(df$player)$last

  #fix stat names
  if (hit_pitch == 'h') {
    hierarchy <- user_settings$h_hierarchy

    names(df)[names(df) == 'pos (20 g)'] <- 'position'
    df$position <- gsub('/', ', ', df$position, fixed = TRUE)

    #make tb
    df <- df %>%
      dplyr::rowwise() %>%
      dplyr::mutate(
        tb = calc_tb(hits, `2b`, `3b`, hr)
      )

  } else if (hit_pitch == 'p') {

    hierarchy <- user_settings$p_hierarchy
    names(df)[names(df) == 'so'] <- 'k'

    #clean up stupid position names
    df$position <- df$role
    df$position <- gsub('S', 'SP', df$position)
    df$position <- gsub('Cl', 'RP', df$position)
    df$position <- gsub('MR', 'RP', df$position)

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
