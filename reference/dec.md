# Unpack shipment and decrypt content

This function tries to reverse the process of [enc](enc.md) and hence
depend on the conventions used there.

## Usage

``` r
dec(tarfile, keyfile = "~/.ssh/id_rsa", target_dir = dirname(tarfile))
```

## Arguments

- tarfile:

  Character string providing full path to the gzip-compressed tarball
  holding the shipment payload, including encrypted files.

- keyfile:

  Character string providing the full path to the private RSA key to be
  used for decryption of the encrypted key that is part of the shipment.
  Default value is set to `~/.ssh/id_rsa` which is the usual path for
  unix type operating systems.

- target_dir:

  Character string providing the full path to where the decrypted file
  is to be written. Defaults to the current directory where the tarfile
  is stored.

## Value

Invisibly a character string providing the file path of the decrypted
file.

## Details

Some of the functions used here might be vulnerable to differences
between systems running R. Possible caveats may be the availability of
the (un)tar-function and how binary streams/files are treated.

## See also

[enc](enc.md)

## Examples

``` r
# Please note that these examples will write files to a local temporary
# directory.

## Make temporary workspace
wd <- tempdir()

## Make a private-public key pair named "id_rsa" and "id_rsa.pub"
keygen(directory = wd, type = "rsa", overwrite_existing = TRUE)
#> sship: Key pair written to /tmp/RtmpGtuGgT

## Make a secured (encrypted) file
saveRDS(iris, file = file.path(wd, "secret.rds"), ascii = TRUE)
pubkey <- readLines(file.path(wd, "id_rsa.pub"))
secure_secret_file <-
  enc(filename = file.path(wd, "secret.rds"),
      pubkey_holder = NULL,
      pubkey = pubkey)
#> sship: Content encrypted and ready for shipment: /tmp/RtmpGtuGgT/secret.rds__20260302_101007.tar.gz

## Decrypt secured file using the private key
secret_file <-
  dec(tarfile = secure_secret_file,
      keyfile = file.path(wd, "id_rsa"),
      target_dir = wd)
#> sship: Decrypted file written to /tmp/RtmpGtuGgT/secret.rds
```
