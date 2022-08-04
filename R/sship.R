#' Secure cargo and make shipment (secure shipment)
#'
#' First, the content (a file) is encrypted and packed and then shipped to the
#' recipient using the specified vessel (transportation method). If the given
#' vessel is not available the function return an error. Optionally, a
#' declaration can also be associated with the shipment and dispatched
#' immediately after the actual cargo.
#'
#' Most likely access control will be enforced before docking of the shipment
#' can commence. For each recipient a list of available vessels (transport
#' methods) is defined and must include relevant credentials. Functions used
#' here rely on local configuration (\code{sship.yml}) to access such
#' credentials.
#'
#' @param content Character string: the full path to the file to be shipped
#' @param recipient Character string: user name uniquely defining the recipient
#' both in terms of the public key used for securing the content and any
#' identity control upon docking. See also \emph{Details}.
#' @param pubkey_holder Character string: the holder of the (recipient's)
#' public key. Currently, the only viable option here is 'github'.
#' @param vessel Character string: means of transportation. Currently one of
#' 'ssh' or 'ftp'.
#' @param declaration Character string: the name of an empty file to be
#' associated with shipment of the cargo itself and dispatched immediately
#' after. The most likely use case is for the recipient to check for this file
#' being present before picking up the cargo itself. Default value is \code{""}
#' in which case no declaration will be used.
#' @param cargo Character vector: all items associated with the current
#' shipment. Used only internally.
#'
#' @seealso \link{enc}
#'
#' @return TRUE if successful
#' @name ship
#' @aliases sship dispatch dispatchable make_url make_opts
NULL


#' @rdname ship
#' @export
sship <- function(content, recipient, pubkey_holder, vessel,
                  declaration = "") {

  if (!dispatchable(recipient, vessel)) {
    stop("The requested shipment cannot be made. Stopping!")
  }

  cargo <- enc(filename = content, pubkey_holder = pubkey_holder,
               pid = recipient)

  if (!identical(declaration, "")) {
    message("sship: Adding declareation to cargo")
    declaration <- file.path(dirname(content), declaration)
    ok <- file.create(declaration)
    if (!all(ok)) {
      stop("sship: Problem creating declaration. Shipment cancelled!")
    }
    cargo <- c(cargo, declaration)
  }

  dispatch(recipient, vessel, cargo)

  invisible()
}

#' @rdname ship
#' @export
dispatch <- function(recipient, vessel, cargo) {

  for (i in seq_len(length(cargo))) {
    message(
      paste("sship: Shipping", cargo[i], "to", recipient, "using", vessel)
    )
    if (vessel == "email") {
      message("sship: Shipping by email not yet implemented...")
    } else {
      url <- make_url(recipient, vessel)
      opts <- make_opts(recipient, vessel)
      if (RCurl::url.exists(url, .opts = opts)) {
        RCurl::ftpUpload(cargo[i], file.path(url, basename(cargo[i])),
                         .opts = opts)
      } else {
        stop(paste0("sship: Url unreachable (for ", recipient, " by ", vessel,
                    "). Does it exist? Shipment Cancelled!"))
      }
    }
  }

  invisible()
}

#' @rdname ship
#' @export
dispatchable <- function(recipient, vessel) {

  conf <- get_config()

  if (!vessel %in% names(conf$recipient[[recipient]])) {
    warning(paste0("The requested transport method is not available for '",
                  recipient, "'. Check config."))
    return(FALSE)
  }

  if (!recipient %in% names(conf$recipient)) {
    warning(paste(paste("Recipient", recipient, "is unknown. Check config.")))
    return(FALSE)
  }

  return(TRUE)

}

#' @rdname ship
#' @export
make_url <- function(recipient, vessel) {

  conf <- get_config()

  url <- character()

  if (vessel == "ftp") {
    url <- paste0("ftp://",
                  conf$recipient[[recipient]]$ftp$user,
                  ":",
                  conf$recipient[[recipient]]$ftp$pass,
                  "@",
                  conf$recipient[[recipient]]$ftp$host,
                  ":",
                  conf$recipient[[recipient]]$ftp$port,
                  "/",
                  conf$recipient[[recipient]]$ftp$path)
  }

  if (vessel == "sftp") {
    url <- paste0("sftp://",
           conf$recipient[[recipient]]$sftp$host,
           ":",
           conf$recipient[[recipient]]$sftp$port,
           "/",
           conf$recipient[[recipient]]$sftp$path)
  }

  url
}

#' @rdname ship
#' @export
make_opts <- function(recipient, vessel) {

  if (vessel == "sftp") {
    sftp <- get_config()$recipient[[recipient]]$sftp
    opts <- list(
      userpwd = paste(sftp$user, sftp$pass, sep = ":"),
      ssh.public.keyfile = sftp$ssh_public_keyfile,
      ssh.private.keyfile = sftp$ssh_private_keyfile,
      keypasswd = sftp$keypasswd
    )
  } else {
    opts <- list()
  }

  opts
}
