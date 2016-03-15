context('zscore')

test_that('zscore works with positional / non-positional groups', {

  s <- get_razzball_steamer(2016)
  s$h <- s$h %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, user_settings$h_hierarchy)
    )
  s$p <- s$p %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      priority_pos = priority_position(position, user_settings$p_hierarchy)
    )

  s_filtered <- limit_proj_vars(s)

  #zscore
  ex1 <- zscore(
    proj_list = s_filtered,
    hit_pitch = 'h'
  )
  ex2 <- zscore(
    proj_list = s_filtered,
    hit_pitch = 'h'
  )

  expect_is(ex1, 'data.frame')
  expect_is(ex2, 'data.frame')

  diffs <- ex2$zscore_sum - ex1$zscore_sum
  expect_true(summary(diffs)[4] %>% abs() < 1)
  expect_true(summary(diffs)[2] %>% abs() < 2)
  expect_true(summary(diffs)[5] %>% abs() < 2)
})
