#' Secure cargo and make shipment (secure shipment)
#'
#' First, the content (a file) is encrypted and packed and then shipped to the
#' recipient using the specified vessel (transportation method). If the given
#' vessel is not available the function return an error. Optionally, a
#' declaration can also be assosiated with the shipment and dispatched
#' immediately after the actual cargo.
#'
#' Most likely access control will be enforced before docking of the shipment
#' can commence. Each vessel holds a list of clients that must contain the
#' named recipient with relevant credentials. Functions used here rely on local
#' configuration (\code{sship.yml}) to access such credentials.
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
#' assosiated with shipment of the cargo itself and dispatched immediately
#' after. The most likely usecase is for the recipient to check for this file
#' being present before picking up the cargo itself. Default value is \code{""}
#' in which case no declaration will be used.
#' @param cargo Character vector: all items assosiated with the current
#' shipment. Used only internally.
#'
#' @seealso \link{enc}
#'
#' @return TRUE if successsful
#' @name ship
#' @aliases sship dispatch dispatchable
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
    message("Adding declareation to cargo")
    declaration <- file.path(dirname(content), declaration)
    silent <- file.create(declaration)
    cargo <- c(cargo, declaration)
  }

  dispatch(recipient, vessel, cargo)

  TRUE
}

#' @rdname ship
#' @export
dispatch <- function(recipient, vessel, cargo) {

  for (i in seq_len(length(cargo))) {
    print(paste("Shipping", cargo[i], "to", recipient, "using", vessel))
  }

  invisible()
}

#' @rdname ship
#' @export
dispatchable <- function(recipient, vessel) {

  conf <- get_config()

  if (!vessel %in% names(conf$vessel)) {
    warning("The requested transport method is not available. Check config.")
    return(FALSE)
  }

  if (!recipient %in% names(conf$vessel[[vessel]]$clients)) {
    warning(paste("Recipient is not eligible for requested transport method.",
                  "Check config."))
    return(FALSE)
  }

  return(TRUE)

}
