context('proj_prep')

test_that('proj_prep object with steamer projections', {

  s <- get_steamer(2016)
  pp <- proj_prep(s)
  head(pp$h) %>% as.data.frame()

  expect_is(pp$h, 'data.frame')
})
