test_that("keygen returns error when type not in c('rsa', 'dsa'", {
  expect_error(keygen(directory = tempdir(), type = "abc"))
})

test_that("a dsa key pair can be made", {
  expect_message(keygen(directory = tempdir(), type = "dsa"))
})

test_that("an rsa key pair can be made", {
  expect_message(keygen(directory = tempdir()))
})

test_that("existing keys will not be overwritten by default", {
  expect_error(keygen(directory = tempdir()))
})

test_that("existing files can be overwritten by force", {
  expect_message(keygen(directory = tempdir(), overwrite_existing = TRUE))
})
