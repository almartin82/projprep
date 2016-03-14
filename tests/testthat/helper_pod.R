#everything here gets run before tests
pod_file <- file.path('paid_projections', 'pod_projections.xlsx')
pod_file_loc <- file.path(getwd(), pod_file)
#for CMD check
pod_file_loc <- gsub('.Rcheck', '', pod_file_loc, fixed = TRUE)
#for devtools::test()
pod_file_loc <- gsub('tests/testthat/', '', pod_file_loc, fixed = TRUE)
pod_ex <- read_raw_pod(pod_file_loc)
