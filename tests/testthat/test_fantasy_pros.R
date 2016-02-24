context("fantasy_pros")

f <- read_raw_fantasy_pros(2016)

test_that("fantasy_pros reads raw data", {

  expect_is(f$h, 'data.frame')
  expect_is(f$p, 'data.frame')

})


test_that("clean_raw_fantasy_pros cleans df", {

  f_clean <- clean_raw_fantasy_pros(f$h)
  head(f_clean) %>% as.data.frame()

})
