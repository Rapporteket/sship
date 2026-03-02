# Functions handling sship R package config

Functions handling sship R package config

## Usage

``` r
create_config(dir = ".")

write_config(config, dir = ".", filename = "_sship.yml")

get_config(dir = ".")

check_config(config)
```

## Arguments

- dir:

  string providing path to configuration file

- config:

  list containing configuration

- filename:

  string defining config filename

## Value

A status message or list of config

## Examples

``` r
# Create a new config file from package default
create_config(dir = tempdir())
#> [1] "/tmp/RtmptvEk6N/_sship.yml file created: fill it in"

# Get config
config <- get_config(system.file("sship.yml", package = "sship"))

# Check if config is valid
check_config(config)

# Write config to file
write_config(config, dir = tempdir())
```
