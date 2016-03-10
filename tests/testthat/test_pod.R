context('pod')

spec_file <- file.path('paid_projections', 'pod_projections.xlsx')
file_loc <- file.path(getwd(), spec_file)
file_loc <- gsub('tests/testthat/', '', file_loc, fixed = TRUE)


test_that('read_raw_pod correctly reads pod excel file', {

  ex <- read_raw_pod(file_loc)
  expect_is(ex, 'list')

})


test_that('clean_raw_pod correctly tidies pod proj', {

  ex <- read_raw_pod(file_loc)
  ex_clean <- clean_raw_pod(ex$h, 'h')
  expect_is(ex_clean, 'data.frame')

  ex <- read_raw_pod(file_loc)
  ex_clean <- clean_raw_pod(ex$p, 'p')
  expect_is(ex_clean, 'data.frame')

})


test_that('get_pod correctly gets and returns pod projcs', {

  ex <- get_pod(file_loc)
  expect_is(ex, 'list')
  expect_is(ex$h, 'data.frame')

})
