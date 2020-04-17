#' Encryption of shipment content
#'
#' Various function and helper functions to establish encrypted files.
#'
#' Encrypted files can be decrypted outside R using the OpenSSL library.
#' Below, a bash shell (unix) example is given.
#' Step 1: decrypt summetric key (open envelope)
#' \preformatted{
#' openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in tempkey.enc -out tempkey
#' }
#' Step 2: decrypt content by key obtained in the above step
#' \preformatted{
#' openssl aes-256-cbc -d -in test.txt.enc -out msg \
#' -K $(hexdump -e '32/1 "\%02x"' tempkey) -iv $(hexdump -e '16/1 "\%02x"' iv)
#' }
#'
#' @param filename string with full y qualified path to a file
#' @param pubkey_holder string defining the provider of the public key used for
#' encryption of the symmetric key. Currently, 'github' is the only valid
#' option.
#' @param pid string uniquely defining the user at 'pubkey_holder' who is also
#' the owner of the  public key
#'
#' @return mosty exit satus?
#' @name enc
#' @aliases enc_filename random_key make_pubkey_url get_pubkey enc_file
NULL


#' @rdname enc
#' @export
enc_filename <- function(filename) {

  paste0(filename, ".enc")

}


#' @rdname enc
#' @export
random_key <- function(bytes = 32) {

  openssl::rand_bytes(bytes)

}

#' @rdname enc
#' @export
make_pubkey_url <- function(pubkey_holder = "github", pid) {

  conf <- get_config()$pubkey$holder[[pubkey_holder]]
  paste0(conf$url, "/", conf$pid$prefix, pid, conf$pid$suffix)

}

#' @rdname enc
#' @export
get_pubkey <- function(pubkey_holder, pid) {

  url <- make_pubkey_url(pubkey_holder, pid)
  print(url)
  cont <- httr::GET(url)
  httr::warn_for_status(cont)

  keys <- httr::content(cont)
  keys <- strsplit(keys, "\n")[[1]]

  if (length(keys) > 1) {
    warning("More than one key found. Only the first one will be used!")
  }

  key <- keys[1]

  if (!grepl("ssh-rsa", key)) {
    stop("The key is not of type 'ssh-rsa'. Cannot go on!")
  }

  openssl::read_pubkey(key)
}


#' @rdname enc
#' @importFrom utils tar
#' @export
enc_file <- function(filename, pubkey_holder, pid) {

  tempkey <- random_key()
  iv <- random_key(16)
  pubkey <- get_pubkey(pubkey_holder, pid)

  blob <- openssl::aes_cbc_encrypt(data = filename, key = tempkey, iv = iv)
  attr(blob, "iv") <- NULL
  ciphertext <- openssl::rsa_encrypt(data = tempkey, pubkey = pubkey)

  # make list of shipment files
  f <- list(blob = enc_filename(filename),
            tempkey = enc_filename(file.path(dirname(filename), "tempkey")),
            iv = file.path(dirname(filename), "iv"))

  writeBin(blob, f$blob)
  writeBin(ciphertext, f$tempkey)
  writeBin(iv, f$iv)

  stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  tarfile <- paste0(basename(filename), stamp, ".tar.gz")
  setwd(dirname(filename))
  tar(tarfile, files = basename(c(f$blob, f$tempkey, f$iv)),
      compression = "gzip", tar = "tar")

  tarfile

}

