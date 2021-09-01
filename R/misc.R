#' Make private-public key pair
#'
#' Just for the convenience of it, make a key pair that may be used alongside
#' sship. Please note that by default the private key will not be protected by
#' a password.
#'
#' @param directory Character string with path to directory where the key pair
#' will be written. Default is \code{normalizePath("~/.ssh")}
#' @param type Character string defining the key type. Must be one of "rsa"
#' (default) or "dsa". Key lengths are set to the default as defined in the
#' \emph{openssl}-package, currently 2048 and 1024, respectively
#' @param password Character string with password to protect the private key.
#' Default value is NULL in which case the private key will not be protected
#' by a password
#'
#' @return Nothing will be returned from this function, but a message containing
#' the directory where the keys were written is provided
#' @export
#'
#' @examples
#' sship_keygen(directory = tempdir())

sship_keygen <- function(directory = normalizePath("~/.ssh"), type = "rsa",
                         password = NULL) {

  stopifnot(type %in% c("rsa", "dsa"))

  if (type == "dsa") {
    key <- openssl::dsa_keygen()
  }

  if (type == "rsa") {
    key <- openssl::rsa_keygen()
  }

  keyfile <- file.path(directory, paste0("id_", type))
  pubkeyfile <- file.path(directory, paste0("id_", type, ".pub"))

  openssl::write_pem(key, keyfile, password = password)
  openssl::write_ssh(key$pubkey, pubkeyfile)

  message(paste("Key pair written to", directory))

  invisible()
}
