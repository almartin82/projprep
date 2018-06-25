context('pod')

pod_file <- file.path('paid_projections', 'pod_projections.xlsx')
pod_file_loc <- file.path(getwd(), pod_file)
#for CMD check
pod_file_loc <- gsub('.Rcheck', '', pod_file_loc, fixed = TRUE)
#for devtools::test()
pod_file_loc <- gsub('tests/testthat/', '', pod_file_loc, fixed = TRUE)
pod_ex <- read_raw_pod(pod_file_loc)


test_that('read_raw_pod correctly reads pod excel file', {
  expect_is(pod_ex, 'list')
})


test_that('clean_raw_pod correctly tidies pod proj', {

  ex_clean <- clean_raw_pod(pod_ex$h, 'h')
  expect_is(ex_clean, 'data.frame')

  ex_clean <- clean_raw_pod(pod_ex$p, 'p')
  expect_is(ex_clean, 'data.frame')
})


test_that('get_pod correctly gets and returns pod projectionss', {

  ex <- get_pod(pod_file_loc)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')
})
