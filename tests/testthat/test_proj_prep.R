context('proj_prep')

test_that('proj_prep object with steamer projections', {

  s <- get_razzball_steamer(2016)
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
  expect_is(pp$h_final, 'data.frame')
  expect_is(pp$p_final, 'data.frame')

})


test_that('proj_prep object with steamer projections', {

  s <- get_razzball_steamer(2016)
  pp <- proj_prep(s)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
  expect_is(pp$replacement, 'list')
  expect_is(pp$special_replacement, 'list')
  expect_is(pp$h_final, 'data.frame')
  expect_is(pp$p_final, 'data.frame')

})


test_that('proj_prep object with cbs projections', {

  cbs_ex <- get_cbs(2016)
  pp <- proj_prep(cbs_ex)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
  expect_is(pp$replacement, 'list')
  expect_is(pp$special_replacement, 'list')
  expect_is(pp$h_final, 'data.frame')
  expect_is(pp$p_final, 'data.frame')
})


test_that('proj_prep object with guru projections', {

  guru_ex <- get_guru(2016)
  pp <- proj_prep(guru_ex)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
  expect_is(pp$replacement, 'list')
  expect_is(pp$special_replacement, 'list')
  expect_is(pp$h_final, 'data.frame')
  expect_is(pp$p_final, 'data.frame')
})


test_that('proj_prep object with pod projections', {

  spec_file <- file.path('paid_projections', 'pod_projections.xlsx')
  file_loc <- file.path(getwd(), spec_file)
  file_loc <- gsub('tests/testthat/', '', file_loc, fixed = TRUE)

  pod_ex <- get_pod(file_loc)
  pp <- proj_prep(pod_ex)

  expect_is(pp$h, 'data.frame')
  expect_is(pp$p, 'data.frame')
  expect_is(pp$replacement, 'list')
  expect_is(pp$special_replacement, 'list')
  expect_is(pp$h_final, 'data.frame')
  expect_is(pp$p_final, 'data.frame')
})
