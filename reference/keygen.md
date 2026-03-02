# Make private-public key pair

Just for the convenience of it, make a key pair that may be used
alongside sship. Please note that by default the private key will not be
protected by a password.

## Usage

``` r
keygen(
  directory = "~/.ssh",
  type = "rsa",
  password = NULL,
  overwrite_existing = FALSE
)
```

## Arguments

- directory:

  Character string with path to directory where the key pair will be
  written. Default is "~/.ssh".

- type:

  Character string defining the key type. Must be one of
  `c("rsa", "dsa", "ecdsa", "x25519", "ed25529")`. Key lengths are set
  to the default as defined in the *openssl*-package. If the key-pair is
  to be used with this package make sure that type is set to "rsa".

- password:

  Character string with password to protect the private key. Default
  value is NULL in which case the private key will not be protected by a
  password

- overwrite_existing:

  Logical whether existing key files with the similar names should be
  overwritten. Set to FALSE by default.

## Value

Nothing will be returned from this function, but a message containing
the directory where the keys were written is provided

## Examples

``` r
keygen(directory = tempdir(), overwrite_existing = TRUE)
#> sship: Key pair written to /tmp/Rtmpsbehii
```
