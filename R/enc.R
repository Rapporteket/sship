#' Encryption of shipment content
#'
#' Various functions and helper functions to establish encrypted files. To
#' secure the content (any file) the Advanced Encryption Standard (AES) is
#' applied with an ephemeral key consisting of 256 random bits. This key is
#' only used once for encryption (and then one more time during decryption at a
#' later stage). A random 128 bit initialization vector (iv) is also applied
#' during encryption. There is no extra security gain in this since the key
#' will never be re-used for encryption/decryption. So, just for good measures
#' then :-) After the content has been encrypted the key itself is encrypted by
#' applying a public key offered by the recipient. This key is obtained from a
#' public provider. Currently, GitHub is the only option. The three files:
#' encrypted content, the encrypted key and the (cleartext) iv is then bundled
#' into a tarball ready for shipment.
#'
#' Encrypted files can be decrypted outside R using the OpenSSL library. Both
#' the key and the initialization vector (iv) are binary and this method uses
#' the key directly (and not a [hashed] passphrase). OpenSSL decryption need to
#' be fed the key (and iv) as a string of hex digits. Methods for conversion
#' from binary to hex may vary between systems. Below, a bash shell (unix)
#' example is given
#' \preformatted{}
#' Step 1: decrypt symmetric key (open envelope) using a private key
#' \preformatted{
#' openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in key.enc -out key
#' }
#' Step 2: decrypt content by key obtained in step 1, also converting key and
#' iv to strings of hexadecimal digits
#' \preformatted{
#' openssl aes-256-cbc -d -in data.csv.enc -out data.csv \
#' -K $(hexdump -e '32/1 "\%02x"' key) -iv $(hexdump -e '16/1 "\%02x"' iv)
#' }
#'
#' @param filename string with fully qualified path to a file
#' @param pubkey_holder string defining the provider of the public key used for
#' encryption of the symmetric key. Currently, 'github' is the only valid
#' option.
#' @param pid string uniquely defining the user at 'pubkey_holder' who is also
#' the owner of the  public key
#'
#' @return Character string providing a filename or a key
#' @seealso \link{dec}
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
make_pubkey_url <- function(pubkey_holder = "github", pid) {

  conf <- get_config()$pubkey$holder[[pubkey_holder]]
  paste0(conf$url, "/", conf$pid$prefix, pid, conf$pid$suffix)

}

#' @rdname enc
#' @export
get_pubkey <- function(pubkey_holder, pid) {

  url <- make_pubkey_url(pubkey_holder, pid)
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

  key
}


#' @rdname enc
#' @importFrom utils tar
#' @export
enc <- function(filename, pubkey_holder, pid) {

  init_dir <- getwd()

  key <- openssl::rand_bytes(32)
  iv <- openssl::rand_bytes(16)
  pubkey <- openssl::read_pubkey(get_pubkey(pubkey_holder, pid))

  blob <- openssl::aes_cbc_encrypt(data = filename, key = key, iv = iv)
  attr(blob, "iv") <- NULL
  ciphertext <- openssl::rsa_encrypt(data = key, pubkey = pubkey)

  # make list of shipment files
  f <- list(blob = enc_filename(filename),
            key = enc_filename(file.path(dirname(filename), "key")),
            iv = file.path(dirname(filename), "iv"))

  writeBin(blob, f$blob)
  writeBin(ciphertext, f$key)
  writeBin(iv, f$iv)

  stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  tarfile <- paste0(basename(filename), "__", stamp, ".tar.gz")
  setwd(dirname(filename))
  tar(tarfile, files = basename(c(f$blob, f$key, f$iv)),
      compression = "gzip", tar = "tar")

  #clean up and move back to init dir
  file.remove(basename(c(f$blob, f$key, f$iv)))
  setwd(init_dir)

  message(paste("Content encrypted and ready for shipment:",
                file.path(dirname(filename), tarfile)))

  invisible(file.path(dirname(filename), tarfile))

}

