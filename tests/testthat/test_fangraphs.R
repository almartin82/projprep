context('fangraphs')

test_that('raw steamer scrape works', {
  ex <- read_raw_steamer()
  expect_is(ex$h, 'data.frame')
})

test_that('read_raw_fangraphs_fans works', {
  ex <- read_raw_fangraphs_fans()
  expect_is(ex$h, 'data.frame')
})
