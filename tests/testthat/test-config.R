tmpdir <- tempdir()

test_that("valid config can be loaded from package", {
  expect_equal(class(get_config(dir = tmpdir)), "list")
  expect_silent(check_config(get_config()))
})

test_that("local config can be handled properly", {
  expect_error(check_config(list()))
  expect_true(grepl("fill it in", create_config(dir = tmpdir)))
  expect_true(grepl("already exists", create_config(dir = tmpdir)))
  expect_equal(class(get_config(dir = tmpdir)), "list")
})

test_that("a config file can be written from local list", {
  conf <- get_config()
  file.remove(file.path(tmpdir, "_sship.yml"))
  expect_invisible(write_config(conf, tmpdir, filename = "sship.yml"))
})

test_that("global config can be defined by env var", {
  Sys.setenv(R_SSHIP_CONFIG_PATH = tmpdir)
  expect_equal(class(get_config(dir = tmpdir)), "list")
  expect_silent(check_config(get_config()))
})
