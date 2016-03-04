
#[(Team Budget – (1*no. of players per team)) / number of players per team]
# * (z-score above replacement / average z-score for above-replacement players)
# + 1 = Dollar Value

#Note: “Draftable” player are considered to be players who are
#projected to produce at a level above replacement level.

#In our case, a 12-team standard league, it would look something like this:

#[(260-(1*23))/23]*(FVARz / average FVARz for above-replacement players) + 1

calculate_prices <- function(pp_list, hit_pitch) {
  initial_message <- sprintf(
    'calculating prices for %s players', hit_pitch
  )
  message(initial_message)

  #grab the df
  this_df <- pp_list %>% magrittr::extract2(hit_pitch)


}
