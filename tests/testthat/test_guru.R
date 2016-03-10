context('guru')

ex <- read_raw_guru(2016)

test_that('raw_guru reads file', {

  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
})


test_that('clean_guru works', {

  ex_clean <- clean_raw_guru(ex$h, 'h')
  expect_is(ex_clean, 'data.frame')

  ex_clean <- clean_raw_guru(ex$p, 'p')
  expect_is(ex_clean, 'data.frame')

})
