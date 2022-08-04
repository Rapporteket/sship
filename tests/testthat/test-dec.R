dir <- tempdir()
dir.create(file.path(dir, "www"))
content_file <- file.path(dir, "content.csv")
write.csv(iris, file = content_file)
key <- openssl::rsa_keygen()
keyfile <- file.path(dir, "id_rsa")
openssl::write_pem(key, path = keyfile)
conf <- get_config()$pubkey$holder$local
pid <- "unittest"
pubkey_filename <- paste0(conf$pid$prefix, pid, conf$pid$suffix)
pubkey_filename <- file.path(dir, "www", pubkey_filename)
openssl::write_ssh(key$pubkey, path = pubkey_filename)


s <- httpuv::startServer(conf$host, port = conf$port,
  app = list(
    staticPaths = list("/" = file.path(dir, "www"))
  )
)

# make an encrypted file and remove source
tarfile <- enc(filename = content_file, pubkey_holder = "local", pid = pid)
file.remove(content_file)

test_that("decryptions errors when private key is not type rsa", {
  expect_error(dec(tarfile, openssl::dsa_keygen()))
  expect_error(dec(tarfile, openssl::ec_keygen()))
  expect_error(dec(tarfile, openssl::x25519_keygen()))
  expect_error(dec(tarfile, openssl::ed25529_keygen()))
})

test_that("decryption function returns invisible", {
  expect_invisible(dec(tarfile, keyfile))
})

test_that("archive contains expected files", {
  expect_true(file.exists("content.csv"))
})

test_that("data is identical before (encryption) and after decryption", {
  write.csv(iris, file = "iris.csv")
  expected <- read.csv("iris.csv")
  data <- read.csv("content.csv")
  expect_identical(data, expected)
})

# clean up
file.remove(tarfile)
file.remove(keyfile)
file.remove(pubkey_filename)
file.remove("iris.csv")
file.remove("content.csv")
file.remove(file.path(dir, "www"))
s$stop()
