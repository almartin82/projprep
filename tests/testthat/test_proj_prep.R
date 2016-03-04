context('proj_prep')

test_that('proj_prep object with steamer projections', {

  s <- get_steamer(2016)
  pp <- proj_prep(s)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
})

test_that('proj_prep object with fantasypros projections', {

  f <- get_fantasy_pros(2016)
  pp <- proj_prep(f)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
  expect_is(pp$replacement, 'list')
  expect_is(pp$special_replacement, 'list')

})
