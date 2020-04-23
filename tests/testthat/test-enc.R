# get config
conf <- get_config()$pubkey$holder$local

# set up httpuv serving files from www at tempdir
dir <- tempdir()
setwd(dir)
dir.create("www")
dir.create("tmp")
s <- httpuv::startServer(conf$host, port = conf$port,
  app = list(
    staticPaths = list("/" = "www")
  )
)

# set testvals and files
pubkey_holder <- "local"
pid <- "unittest"
pubkey_filename <- paste0(conf$pid$prefix, pid, conf$pid$suffix)
pubkey_filepath <- file.path(dir, "www", pubkey_filename)
pubkey_url <- paste0(conf$url, "/", pubkey_filename)
write.csv(iris, file = "content.csv")
content_file <- normalizePath("content.csv")


test_that("a filename for the encrypted file can be provided", {
  expect_equal(enc_filename("test"),
               paste0("test", get_config()$file$encrypt$suffix))
})

test_that("an url can be provided", {
  expect_equal(make_pubkey_url(pubkey_holder = "local", pid = pid),
               pubkey_url)
})

# test response for a none RSA key
key <- openssl::dsa_keygen()
writeLines(openssl::write_ssh(key$pubkey), pubkey_filepath, sep = "")
test_that("error is provided when none RSA key", {
  expect_error(enc(content_file, pubkey_holder = "local", pid = pid),
               regexp = "ssh-rsa")
})
file.remove(pubkey_filepath)

# tests on true RSA key
key <- openssl::rsa_keygen()
writeLines(openssl::write_ssh(key$pubkey), pubkey_filepath, sep = "")

test_that("a message is returned", {
  file.copy("content.csv", "tmp/content.csv")
  setwd("tmp/")
  expect_message(enc("content.csv", pubkey_holder = "local", pid = pid))
  setwd("../.")
  unlink("tmp/*")
})

test_that("function returns invisibly", {
  file.copy("content.csv", "tmp/content.csv")
  setwd("tmp/")
  expect_invisible(enc("content.csv", pubkey_holder = "local", pid = pid))
  setwd("../.")
  unlink("tmp/*")
})

test_that("a file name can be obtained from the function", {
  file.copy("content.csv", "tmp/content.csv")
  setwd("tmp/")
  f <- enc("content.csv", pubkey_holder = "local", pid = pid)
  expect_true(file.exists(f))
  setwd("../.")
  unlink("tmp/*")
})

# test warning when multiple public keys available
pk <- openssl::write_ssh(key$pubkey)
writeLines(c(pk, pk), pubkey_filepath, sep = "\n")
test_that("function provide warning when multiple pubkeys", {
  file.copy("content.csv", "tmp/content.csv")
  setwd("tmp/")
  expect_warning(enc("content.csv", pubkey_holder = "local", pid = pid))
  setwd("../.")
  unlink("tmp/*")
})

# clean up
file.remove(pubkey_filepath)
file.remove("content.csv")
setwd(dir)
file.remove("www")
s$stop()
