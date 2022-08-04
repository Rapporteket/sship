#' Make private-public key pair
#'
#' Just for the convenience of it, make a key pair that may be used alongside
#' sship. Please note that by default the private key will not be protected by
#' a password.
#'
#' @param directory Character string with path to directory where the key pair
#' will be written. Default is "~/.ssh".
#' @param type Character string defining the key type. Must be one of
#' \code{c("rsa", "dsa", "ecdsa", "x25519", "ed25529")}. Key lengths are set to
#' the default as defined in the \emph{openssl}-package. If the key-pair is to
#' be used with this package make sure that type is set to "rsa".
#' @param password Character string with password to protect the private key.
#' Default value is NULL in which case the private key will not be protected
#' by a password
#' @param overwrite_existing Logical whether existing key files with the similar
#' names should be overwritten. Set to FALSE by default.
#'
#' @return Nothing will be returned from this function, but a message containing
#' the directory where the keys were written is provided
#' @export
#'
#' @examples
#' keygen(directory = tempdir(), overwrite_existing = TRUE)

keygen <- function(directory = "~/.ssh", type = "rsa",
                         password = NULL, overwrite_existing = FALSE) {

  directory <- normalizePath(directory)

  stopifnot(type %in% c("rsa", "dsa", "ecdsa", "x25519", "ed25519"))

  key <- switch(type,
    rsa = openssl::rsa_keygen(),
    dsa = openssl::dsa_keygen(),
    ecdsa = openssl::ec_keygen(),
    x25519 = openssl::x25519_keygen(),
    ed25519 = openssl::ed25519_keygen()
  )

  if (type != "rsa") {
    warning("Only RSA keys allow a fully functional sship.")
  }

  keyfile <- file.path(directory, paste0("id_", type))
  pubkeyfile <- file.path(directory, paste0("id_", type, ".pub"))

  if (any(file.exists(keyfile, pubkeyfile)) && !overwrite_existing) {
    stop(paste("Key files exists! If you really want to overwrite existing",
               "files, please set the function argument 'overwrite_existing'",
               "to TRUE. Terminating."))
  }

  openssl::write_pem(key, keyfile, password = password)
  openssl::write_ssh(key$pubkey, pubkeyfile)

  message(paste("sship: Key pair written to", directory))

  invisible()
}

#' Filter ssh public keys by type
#'
#' From a vector of ssh public keys, return those that are of a given type.
#'
#' @param keys Vector of strings representing ssh public keys.
#' @param type Character string defining the ssh public key type that will pass
#' the filter. Relevant values are strings returned by
#' \code{attributes(openssl::read_pubkey(pubkey))$class[2]}, \emph{e.g.} "rsa"
#' and "dsa".
#'
#'
#' @return A vector of strings representing (filtered) public keys.
#' @export
#'
#' @examples
#' ## make ssh public key strings
#' rsa_pubkey <- openssl::write_ssh(openssl::rsa_keygen()$pubkey)
#' dsa_pubkey <- openssl::write_ssh(openssl::dsa_keygen()$pubkey)
#'
#' ## filter keys by type
#' pubkey <- pubkey_filter(c(rsa_pubkey, dsa_pubkey), "rsa")
#' identical(pubkey, rsa_pubkey)

pubkey_filter <- function(keys, type) {

  pass <- function(key, type) inherits(openssl::read_pubkey(key), type)

  keys[vapply(keys, pass, logical(length = 1), type = type)]
}
