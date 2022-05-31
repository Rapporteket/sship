test_that("keygen returns error when type not known", {
  expect_error(keygen(directory = tempdir(), type = "abc"))
})

test_that("an rsa key pair can be made", {
  expect_message(keygen(directory = tempdir()))
  expect_warning(
    keygen(directory = tempdir(), type = "rsa", overwrite_existing = TRUE),
    regexp = NA
  )
})

defaultW <- getOption("warn")

test_that("a dsa key pair can be made", {
  expect_warning(
    keygen(directory = tempdir(), type = "dsa", overwrite_existing = TRUE)
  )
  options(warn = -1)
  expect_message(
    keygen(directory = tempdir(), type = "dsa", overwrite_existing = TRUE)
  )
  options(warn = defaultW)
})

test_that("an ecdsa key pair can be made", {
  expect_warning(
    keygen(directory = tempdir(), type = "ecdsa", overwrite_existing = TRUE)
  )
  options(warn = -1)
  expect_message(
    keygen(directory = tempdir(), type = "ecdsa", overwrite_existing = TRUE)
  )
  options(warn = defaultW)
})

test_that("an x25519 key pair can be made", {
  expect_warning(
    keygen(directory = tempdir(), type = "x25519", overwrite_existing = TRUE)
  )
  options(warn = -1)
  expect_message(
    keygen(directory = tempdir(), type = "x25519", overwrite_existing = TRUE)
  )
  options(warn = defaultW)
})

test_that("an ed25519 key pair can be made", {
  expect_warning(
    keygen(directory = tempdir(), type = "ed25519", overwrite_existing = TRUE)
  )
  options(warn = -1)
  expect_message(
    keygen(directory = tempdir(), type = "ed25519", overwrite_existing = TRUE)
  )
  options(warn = defaultW)
})

test_that("existing keys will not be overwritten by default", {
  expect_error(keygen(directory = tempdir()))
})

test_that("existing files can be overwritten by force", {
  expect_message(keygen(directory = tempdir(), overwrite_existing = TRUE))
})

test_that("ssh public keys can be filtered by type", {
  rsa_pubkey <- openssl::write_ssh(openssl::rsa_keygen()$pubkey)
  dsa_pubkey <- openssl::write_ssh(openssl::dsa_keygen()$pubkey)
  pubkey <- pubkey_filter(c(rsa_pubkey, dsa_pubkey), "rsa")
  expect_identical(pubkey, rsa_pubkey)
})
