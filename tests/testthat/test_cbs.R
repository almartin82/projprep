context('cbs')

test_that('cbs scrape works for hitters', {

  ex <- read_raw_cbs(2016)

  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})


test_that('clean cbs works', {

  ex <- read_raw_cbs(2016)

  ex_clean <- clean_raw_cbs(ex$h, 'h')
  expect_is(ex_clean, 'data.frame')

  ex_clean <- clean_raw_cbs(ex$p, 'p')
  expect_is(ex_clean, 'data.frame')
})
