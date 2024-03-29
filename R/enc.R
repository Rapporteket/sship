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
#' @param filename Character string with fully qualified path to a file.
#' @param pubkey_holder Character string defining the provider of the public key
#'   used for encryption of the symmetric key. Currently, 'github' is the only
#'   valid pubkey holder. If a local pubkey is to be used (see parameter
#'   \code{pubkey}, \code{pubkey_holder} may be set to NULL or some other value.
#' @param pid Character string uniquely defining the user at
#'   \code{pubkey_holder} who is also the owner of the  public key.
#' @param pubkey Character string representing a valid public key. Default is
#'   NULL in which case the key will be obtained as per \code{pubkey_holder}.
#'
#' @return Character string providing a filename or a key
#' @seealso \link{dec}
#' @name enc
#' @aliases enc_filename random_key make_pubkey_url get_pubkey enc_file
#' @examples
#' # Please note that these examples will write files to a local temporary
#' # directory.
#'
#' ## Define temporary working directory and a secret file name
#' wd <- tempdir()
#' secret_file_name <- "secret.rds"
#'
#' ## Add content to the secret file
#' saveRDS(iris, file = file.path(wd, secret_file_name), ascii = TRUE)
#'
#' ## Make a private-public key pair named "id_rsa" and "id_rsa.pub"
#' keygen(directory = wd, type = "rsa", overwrite_existing = TRUE)
#'
#' ## Load public key
#' pubkey <- readLines(file.path(wd, "id_rsa.pub"))
#'
#' ## Make a secured file (ready for shipment)
#' secure_secret_file <- enc(filename = file.path(wd, "secret.rds"),
#'                           pubkey_holder = NULL, pubkey = pubkey)
NULL


#' @rdname enc
#' @export
enc_filename <- function(filename) {

  suffix <- get_config()$file$encrypt$suffix
  paste0(filename, suffix)

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

  if (pubkey_holder == "file") {
    key <- openssl::read_pubkey(get_config()$pubkey$holder$file$path)$ssh
  } else {
    url <- make_pubkey_url(pubkey_holder, pid)
    cont <- httr::GET(url)
    httr::warn_for_status(cont)

    keys <- httr::content(cont, as = "text")
    keys <- strsplit(keys, "\n")[[1]]

    if (length(keys) > 1) {
      warning(
        "More than one key found. Only the first viable key will be used!"
      )
    }

    keys <- pubkey_filter(keys, "rsa")

    if (length(keys) < 1) {
      stop("No RSA public key found. Cannot go on!")
    }

    key <- keys[1]
  }

  key
}


#' @rdname enc
#' @importFrom utils tar untar
#' @export
enc <- function(filename, pubkey_holder, pid, pubkey = NULL) {

  init_dir <- getwd()
  on.exit(setwd(init_dir))

  key <- openssl::rand_bytes(32)
  iv <- openssl::rand_bytes(16)
  if (is.null(pubkey)) {
    pubkey <- openssl::read_pubkey(get_pubkey(pubkey_holder, pid))
  }

  blob <- sym_enc(data = filename, key = key, iv = iv)
  attr(blob, "iv") <- NULL
  ciphertext <- openssl::rsa_encrypt(data = key, pubkey = pubkey)

  # for tar (on old R versions) we need a dedicated, pristine work directory
  wd <- file.path(tempdir(), "sship")
  dir.create(wd)

  # make list of shipment files
  stamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  f <- list(blob = enc_filename(file.path(wd, basename(filename))),
            key = enc_filename(file.path(wd, "key")),
            iv = file.path(wd, "iv"),
            tarfile = file.path(dirname(filename),
                                paste0(basename(filename), "__",
                                       stamp, ".tar.gz")))

  writeBin(blob, f$blob)
  writeBin(ciphertext, f$key)
  writeBin(iv, f$iv)

  tarfile <- paste0(basename(filename), "__", stamp, ".tar.gz")
  setwd(wd)

  tar(tarfile = tarfile, compression = "gzip", tar = "internal")

  # take hold of tar archive before cleanup
  file.copy(tarfile, f$tarfile)
  # clean up
  setwd(init_dir)
  unlink(file.path(wd, "*"))
  unlink(wd)
  file.remove(wd)

  message(paste("sship: Content encrypted and ready for shipment:", f$tarfile))

  invisible(f$tarfile)

}


#' Standard sship symmetric encryption
#'
#' @param data raw vector or path to file with data to encrypt or decrypt
#' @param key raw vector of length 16, 24 or 32, e.g. the hash of a shared
#'   secret
#' @param iv raw vector of length 16 (aes block size) or NULL. The
#'   initialization vector is not secret but should be random
#'
#' @return A raw vector of encrypted \code{data}.
#' @keywords internal
#' @export

sym_enc <- function(data, key, iv = openssl::rand_bytes(16)) {

  openssl::aes_cbc_encrypt(data, key, iv)
}
