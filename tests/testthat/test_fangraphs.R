context('fangraphs')

test_that('raw steamer scrape works', {
  ex <- read_raw_steamer()
  expect_is(ex$h, 'data.frame')
})


test_that('raw steamer600 scrape works', {
  ex <- read_raw_steamer600()
  expect_is(ex$h, 'data.frame')
})


test_that('raw fangraphs fans scrape works', {
  ex <- read_raw_fangraphs_fans()
  expect_is(ex$h, 'data.frame')
})


test_that('raw zips scrape works', {
  ex <- read_raw_zips()
  expect_is(ex$h, 'data.frame')
})
