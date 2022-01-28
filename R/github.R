#' Make calls to the github API
#'
#' Provides a structured list of the specified resource from the the github API.
#'
#' For most use cases only \code{gh()} will be relevant. The helper function
#' \code{github_api()} do the actual lifting while \code{rate_limit()} handles
#' API rate limits.
#'
#' @param path Character string with path to the API resource.
#' @param proxy_url Character string defining a network proxy in the form
#' host:port. Default is NULL in which case the API call will not use a proxy.
#'
#' @return A list of class github_api containing the parsed content, API
#' resource path and the response object. For \code{rate_limit()} the path is
#' always "/rate_limit" and can hence be used to detect if the limit is exceeded
#' (without being counted as a request itself). If the allowed API rate is
#' exceeded \code{gh()} will return a message stating the fact and simple
#' suggestions on how to remedy the problem.
#'
#' @name github
#' @aliases gh github_api rate_limit
#'
#' @examples
#' ## Get all branches of a repository. If the api rate limit is exceeded this
#' ## function will return NULL and an informative message
#' gh("repos/Rapporteket/sship/branches")
#'
#' ## helper functions that will normally not be used
#' github_api("/rate_limit")
#' rate_limit()
NULL

#' @rdname github
#' @export
gh <- function(path, proxy_url = NULL) {

  # simply end with NULL and an informative message if rate limit is exceeded
  rl <- rate_limit(proxy_url = proxy_url)
  if (rl$content$rate$remaining < 1) {
    reset <- as.POSIXct(rl$content$rate$reset, origin = "1970-01-01")
    message("API rate limit is exceeded! You may have to wait until your",
            " limit is reset at ", strftime(reset, "%H:%M:%S"), " GMT ",
            "or set env var GITHUB_PAT to your github ",
            "personal access token to increase your limit.")
    return(NULL)
  }

  github_api(path, proxy_url)
}

#' @rdname github
#' @export
github_api <- function(path, proxy_url = NULL) {

  url <- httr::modify_url("https://api.github.com", path = path)
  user_agent <- httr::user_agent("https://github.com/Rapporteket/sship")

  if (!is.null(proxy_url)) {
    httr::set_config(httr::use_proxy(url = proxy_url))
  }

  resp <- httr::GET(url, user_agent)
  if (httr::http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(httr::content(resp, "text"),
                               simplifyVector = TRUE)

  if (httr::status_code(resp) != 200) {
    stop(
      sprintf(
        "GitHub API request failed [%s]\n%s\n<%s>",
        httr::status_code(resp),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }

  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "github_api"
  )
}

#' @rdname github
#' @export
rate_limit <- function(proxy_url = NULL) {

  github_api("/rate_limit", proxy_url)
}
