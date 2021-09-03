# get config
conf <- get_config()$pubkey$holder$local

# set up httpuv serving files from www at tempdir
dir <- tempdir()
dir.create(file.path(dir, "www"))
dir.create(file.path(dir, "tmp"))
s <- httpuv::startServer(conf$host, port = conf$port,
  app = list(
    staticPaths = list("/" = file.path(dir, "www"))
  )
)

# set testvals and files
pubkey_holder <- "local"
pid <- "unittest"
pubkey_filename <- paste0(conf$pid$prefix, pid, conf$pid$suffix)
pubkey_filepath <- file.path(dir, "www", pubkey_filename)
pubkey_url <- paste0(conf$url, "/", pubkey_filename)
write.csv(iris, file = file.path(dir, "content.csv"))
content_file <- normalizePath(file.path(dir, "content.csv"))


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
  file.copy(content_file, file.path(dir, "tmp/content.csv"))
  expect_message(
    enc(file.path(dir, "tmp/content.csv"), pubkey_holder = "local", pid = pid))
  unlink(file.path(dir, "tmp/*"))
})

test_that("function returns invisibly", {
  file.copy(content_file, file.path(dir, "tmp/content.csv"))
  expect_invisible(
    enc(file.path(dir, "tmp/content.csv"), pubkey_holder = "local", pid = pid))
  unlink(file.path(dir, "tmp/*"))
})

test_that("a file name can be obtained from the function", {
  file.copy(content_file, file.path(dir, "tmp/content.csv"))
  f <- enc(file.path(dir, "tmp/content.csv"), pubkey_holder = "local",
           pid = pid)
  expect_true(file.exists(f))
  unlink(file.path(dir, "tmp/*"))
})

# test warning when multiple public keys available
pk <- openssl::write_ssh(key$pubkey)
writeLines(c(pk, pk), pubkey_filepath, sep = "\n")
test_that("function provide warning when multiple pubkeys", {
  file.copy(content_file, file.path(dir, "tmp/content.csv"))
  expect_warning(
    enc(file.path(dir, "tmp/content.csv"), pubkey_holder = "local", pid = pid))
  unlink(file.path(dir, "tmp/*"))
})

# test encryption with local pubfile
conf <- get_config()
file.copy(content_file, file.path(dir, "tmp/content.csv"))
pk <- openssl::write_ssh(key$pubkey)
local_pubkey_filepath <- file.path(dir, "tmp", conf$pubkey$holder$file$path)
writeLines(pk, local_pubkey_filepath, sep = "")
# fake config
conf$pubkey$holder$file$path <- local_pubkey_filepath
write_config(config = conf, dir = file.path(dir, "tmp"))
conf <- get_config(dir = file.path(dir, "tmp"))
test_that("encryption can be made by local pub-file", {
  expect_invisible(
    enc(file.path(dir, "tmp/content.csv"), pubkey_holder = NULL, pid = pid,
        pubkey = local_pubkey_filepath)
  )
  unlink(file.path(dir, "tmp/*"))
})

# clean up
file.remove(pubkey_filepath)
file.remove(file.path(dir, "content.csv"))
file.remove(file.path(dir, "www"))
s$stop()
