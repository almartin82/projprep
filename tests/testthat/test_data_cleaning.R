context('data_cleaning')

samp_positions <- c('1B', 'SS', 'OF')
samp_hierarchy <- c('C', 'SS', '2B', '3B', 'OF', '1B')

test_that('tag position correctly identifies the priority of different positions', {

  samp_priorities <- tag_position(samp_positions, samp_hierarchy)
  expect_equal(samp_priorities, c(6, 2, 5))

})


test_that('priority position identifies scarcest position', {

  ex <- priority_position(samp_positions, samp_hierarchy)
  expect_equal(ex, 'SS')

})
