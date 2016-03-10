context('pod')

test_that('read_raw_pod correctly reads pod excel file', {

  ex <- read_raw_pod(file.path('paid_projections', 'pod_projections.xlsx'))
  expect_is(ex, 'list')

})
