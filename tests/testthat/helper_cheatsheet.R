#everything here gets run before tests
cheatsheet_file <- file.path('paid_projections', 'mr_cheatsheet.xlsm')
cheatsheet_file_loc <- file.path(getwd(), cheatsheet_file)
#for CMD check
cheatsheet_file_loc <- gsub('.Rcheck', '', cheatsheet_file_loc, fixed = TRUE)
#for devtools::test()
cheatsheet_file_loc <- gsub('tests/testthat/', '', cheatsheet_file_loc, fixed = TRUE)
