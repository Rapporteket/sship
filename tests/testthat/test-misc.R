test_that("keygen returns error when type not in c('rsa', 'dsa'", {
  expect_error(sship_keygen(directory = tempdir(), type = "abc"))
})

test_that("a dsa key pair can be made", {
  expect_message(sship_keygen(directory = tempdir(), type = "dsa"))
})

test_that("an rsa key pair can be made", {
  expect_message(sship_keygen(directory = tempdir()))
})
