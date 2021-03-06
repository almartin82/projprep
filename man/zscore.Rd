% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zscore.R
\name{zscore}
\alias{zscore}
\title{zscore}
\usage{
zscore(proj_list, hit_pitch, stat_direction = user_settings \%>\%
  magrittr::extract2(paste0(hit_pitch, "_higher_better")),
  is_rate = user_settings \%>\% magrittr::extract2(paste0(hit_pitch,
  "_rate")), limit_player_pool = TRUE)
}
\arguments{
\item{proj_list}{named ('h', 'p') list of data frames, ie output of get_steamer}

\item{hit_pitch}{'h' or 'p'}

\item{stat_direction}{vector that flags if the stat is
reverse-framed (lower = better).  default behavior is
to read from user_settings.}

\item{is_rate}{vector that flags if the state is a rate stat.
default behavior is to read from user_settings.}

\item{limit_player_pool}{zscores relative to all players, or relative size of drafted
player pool?}
}
\value{
list of data frames with stat zscores
}
\description{
zscore
}

