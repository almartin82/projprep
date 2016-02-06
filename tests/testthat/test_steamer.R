context('steamer')

test_that('steamer reads raw data', {
  s <- read_raw_steamer(2016)

  expect_is(s, 'list')
  expect_is(s$h, 'data.frame')
  expect_is(s$p, 'data.frame')

  expect_true('Mike Trout' %in% s$h$Name)
  expect_true('Clayton Kershaw' %in% s$p$Name)
})


test_that('steamer reads and cleans raw data', {
  s <- read_and_clean_steamer(2016)

  expect_is(s, 'list')
  expect_is(s$h, 'data.frame')
  expect_is(s$p, 'data.frame')

  expect_true('FirstName' %in% names(s$h))
  expect_true('Mike Trout' %in% s$h$FullName)
  expect_true('Clayton Kershaw' %in% s$p$FullName)

})
