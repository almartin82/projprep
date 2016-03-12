context('steamer')

test_that('steamer reads raw data', {
  s <- read_raw_razzball_steamer(2016)

  expect_is(s, 'list')
  expect_is(s$h, 'data.frame')
  expect_is(s$p, 'data.frame')

  expect_true('Mike Trout' %in% s$h$Name)
  expect_true('Clayton Kershaw' %in% s$p$Name)
})


test_that('get_razzball_steamer reads and cleans raw data', {
  s <- get_razzball_steamer(2016)

  expect_is(s, 'list')
  expect_is(s$h, 'data.frame')
  expect_is(s$p, 'data.frame')

  expect_true('firstname' %in% names(s$h))
  expect_true('Mike Trout' %in% s$h$fullname)
  expect_true('Clayton Kershaw' %in% s$p$fullname)

  expect_true(all(c('ip', 'w', 'k', 'era', 'whip', 'sv') %in% names(s$p)))
})
