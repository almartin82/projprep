context('cbs')

test_that('cbs scrape works for hitters', {

  ex <- read_raw_cbs(2016)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})
