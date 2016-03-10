context('pod')

test_that('read_raw_pod correctly reads pod excel file', {

  ex <- read_raw_pod(file.path('paid_projections', 'pod_projections.xlsx'))
  expect_is(ex, 'list')

})


test_that('clean_raw correctly tidies pod proj', {

  ex <- read_raw_pod(file.path('paid_projections', 'pod_projections.xlsx'))
  ex_clean <- clean_raw_pod(ex$h, 'h')
  expect_is(ex_clean, 'data.frame')

  ex <- read_raw_pod(file.path('paid_projections', 'pod_projections.xlsx'))
  ex_clean <- clean_raw_pod(ex$p, 'p')
  expect_is(ex_clean, 'data.frame')

})
