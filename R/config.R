#' Functions handling sship R package config
#'
#' @param dir string providing path to configuration file
#' @param config list containing configuration
#' @param filename string defining config filename
#'
#' @return A status message or list of config
#' @name config
#' @aliases create_config get_config check_config
#' @examples
#' # Create a new config file from package default
#' create_config(dir = tempdir())
#'
#' # Get config
#' config <- get_config(system.file("sship.yml", package = "sship"))
#'
#' # Check if config is valid
#' check_config(config)
#'
#' # Write config to file
#' write_config(config, dir = tempdir())
NULL


#' @rdname config
#' @export
create_config <- function(dir = ".") {
  ref_file <- system.file("sship.yml", package = "sship")
  new_file <- paste(dir, "_sship.yml", sep = "/")
  if (!file.exists(new_file)) {
    file.copy(ref_file, to = new_file)
    return(paste0(new_file, " file created: fill it in"))
  } else {
    return(paste0("Cannot create ", new_file, " config file: already exists"))
  }
}

#' @rdname config
#' @export
write_config <- function(config, dir = ".", filename = "_sship.yml") {
  check_config(config)
  config_file <- paste(dir, filename, sep = "/")
  yaml::write_yaml(config, file = config_file)
  invisible()
}

#' @rdname config
#' @export
get_config <- function(dir = ".") {
  config_file <- file.path(dir, "_sship.yml")
  if (!file.exists(config_file)) {
    config_path <- Sys.getenv("R_SSHIP_CONFIG_PATH")
    config_file <- file.path(config_path, "sship.yml")
    if (config_path == "" | !file.exists(config_file)) {
      config_file <- system.file("sship.yml", package = "sship")
    }
  }
  config <- yaml::read_yaml(config_file)
  check_config(config)
  return(config)
}


#' @rdname config
#' @export
check_config <- function(config) {
  if ((class(config) != "list") | (!("pubkey" %in% attributes(config)$names))) {
    stop("Complete the config file: _sship.yml")
  }
  invisible()
}
