context('fangraphs')

steamer_ex <- read_raw_steamer()

test_that('raw steamer scrape works', {
  expect_is(steamer_ex$h, 'data.frame')
})


test_that('raw steamer600 scrape works', {
  ex <- read_raw_steamer600()
  expect_is(ex$h, 'data.frame')
})


test_that('raw zips scrape works', {
  ex <- read_raw_zips()
  expect_is(ex$h, 'data.frame')
})


test_that('clean fangraphs works', {

  clean_h <- clean_raw_fangraphs(steamer_ex$h, 'h')
  clean_p <- clean_raw_fangraphs(steamer_ex$p, 'p')

  expect_is(clean_h, 'data.frame')
  expect_is(clean_p, 'data.frame')
})


test_that('get fangraphs works', {

  ex <- get_fangraphs(2016, 'steamer')
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})


test_that('get steamer works', {

  ex <- get_steamer(2016, TRUE)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})


test_that('get steamer600 works', {

  ex <- get_steamer600(2016, TRUE)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})


test_that('get fangraphs depth charts works', {

  ex <- get_fangraphs_depth_charts(2016, TRUE)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})


test_that('get zips works', {

  ex <- get_zips(2016, TRUE)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})
