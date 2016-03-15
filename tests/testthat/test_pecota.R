context('pecota')


test_that('manual read raw pecota', {
  ex <- read_raw_pecota(file.path('paid_projections', 'pecota.xls'))
  expect_is(ex$h, 'data.frame')
})

test_that('read raw pecota works', {

  expect_is(pecota_ex, 'list')
  expect_is(pecota_ex$h, 'data.frame')
  expect_is(pecota_ex$p, 'data.frame')
})
