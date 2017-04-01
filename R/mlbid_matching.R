#' first pass mlbid match
#'
#' @description first get the easy ones - the players for whom there
#' is one, and only one, match on the exact spelling of their full name
#' @param name_vector character vector of names to match
#'
#' @return vector of mlbids
#' @export

first_pass_mlbid <- function(name_vector) {

  clean_map <- id_map
  #stupid quotes
  clean_map$playername <- clean_quotes(clean_map$playername)
  clean_map$playername <- tolower(clean_map$playername)
  name_vector <- clean_quotes(name_vector)
  name_vector <- tolower(name_vector)

  exact_matches <- lapply(name_vector, function(x) {
    matches <- clean_map[clean_map$playername == x, ]

    if (nrow(matches) == 1) {
      out <- matches$mlbid
    } else {
      out <- NA
    }

    out
  })

  #be defensive for NULLS in exact_matches
  exact_matches[sapply(exact_matches, is.null)] <- NA
  unlist(unname(exact_matches))
}


#' second pass id match
#'
#' @param name_vector vector of names
#' @param mlbid_vector vector of ids
#'
#' @return vector of ids, hopefully with more matches
#' @export

second_pass_mlbid <- function(name_vector, mlbid_vector) {

  name_vector <- clean_quotes(name_vector)
  name_vector <- tolower(name_vector)
  name_key <- paste0(name_vector, seq(1:length(name_vector)))

  master_data <- data.frame(
    name = name_vector,
    name_key = name_key,
    mlbid = mlbid_vector,
    stringsAsFactors = FALSE
  )

  to_search <- master_data %>%
    dplyr::filter(is.na(mlbid))

  more_names <- c(
    "fangraphsname", "mlbname", "cbsname", "nfbcname", "espnname",
    "kfflname", "yahooname", "mstrbllname", "fantprosname",
    "fanduelname", "draftkingsname")

  mlbid_matches <- list()

  for (i in more_names) {
    #search df has a vector of names and the mlbid
    search_df <- data.frame(
      name = id_map[, i] %>% unlist() %>% unname(),
      mlbid = id_map$mlbid,
      stringsAsFactors = FALSE
    )
    search_df$name <- clean_quotes(search_df$name)
    search_df$name <- tolower(search_df$name)

    id_matches <- lapply(to_search$name, function(x){
      matches <- search_df[search_df$name == x & !is.na(search_df$name), ]

      if (nrow(matches) == 1) {
        out <- matches$mlbid
      } else {
        out <- NA
      }

      out
    })

    id_matches[sapply(id_matches, is.null)] <- NA
    result <- unlist(unname(id_matches))
    mlbid_matches[[i]] <- result
  }

  #bind together, return one matching id
  after_matching_df <- dplyr::bind_rows(mlbid_matches)
  #look colwise, grab one id
  matched_id <- suppressWarnings(
    apply(after_matching_df, 1, function(x) min(x, na.rm = TRUE))
  )
  matched_id <- ifelse(is.infinite(matched_id), NA, matched_id)
  after_matching_df$new_mlbid <- matched_id
  after_matching_df$name <- to_search$name
  after_matching_df$name_key <- to_search$name_key

  master_data <- master_data %>%
    dplyr::left_join(
      x = .,
      y = after_matching_df[, c('name_key', 'new_mlbid')],
      by = 'name_key'
    )

  master_data$mlbid <- ifelse(
    is.na(master_data$mlbid), master_data$new_mlbid, master_data$mlbid
  )

  master_data$mlbid
}


#' mlbid match
#'
#' @description wrapper around id matching functions that
#' attempts to match player names to an id
#' @param df cleaned df, eg output of clean_raw_razzball_steamer
#'
#' @return vector of ids
#' @export

mlbid_match <- function(df) {

  mlbids1 <- first_pass_mlbid(df$fullname)
  mlbids2 <- second_pass_mlbid(df$fullname, mlbids1)
  df$mlbid <- mlbids2
}

