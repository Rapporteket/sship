# Standard sship symmetric decryption

Standard sship symmetric decryption

## Usage

``` r
sym_dec(data, key, iv = attr(data, "iv"))
```

## Arguments

- data:

  raw vector or path to file with data to encrypt or decrypt

- key:

  raw vector of length 16, 24 or 32, e.g. the hash of a shared secret

- iv:

  raw vector of length 16 (aes block size) or NULL. The initialization
  vector is not secret but should be random

## Value

A raw vector of decrypted `data`.
