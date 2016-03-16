context('pecota')


test_that('manual read raw pecota', {
  ex <- read_raw_pecota(file.path('paid_projections', 'pecota_2016.xls'))
  expect_is(ex$h, 'data.frame')
})

test_that('read raw pecota works', {
  expect_is(pecota_ex, 'list')
  expect_is(pecota_ex$h, 'data.frame')
  expect_is(pecota_ex$p, 'data.frame')
})


test_that('clean raw pecota works', {
  ex <- clean_raw_pecota(pecota_ex$h, 'h')
  expect_is(ex, 'data.frame')

  ex <- clean_raw_pecota(pecota_ex$p, 'p')
  expect_is(ex, 'data.frame')
})


test_that('get pecota works', {
  ex <- get_pecota(pecota_file_loc, TRUE)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
  expect_is(ex$p, 'data.frame')
})

