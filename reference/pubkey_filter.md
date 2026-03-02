# Filter ssh public keys by type

From a vector of ssh public keys, return those that are of a given type.

## Usage

``` r
pubkey_filter(keys, type)
```

## Arguments

- keys:

  Vector of strings representing ssh public keys.

- type:

  Character string defining the ssh public key type that will pass the
  filter. Relevant values are strings returned by
  `attributes(openssl::read_pubkey(pubkey))$class[2]`, *e.g.* "rsa" and
  "dsa".

## Value

A vector of strings representing (filtered) public keys.

## Examples

``` r
## make ssh public key strings
rsa_pubkey <- openssl::write_ssh(openssl::rsa_keygen()$pubkey)
dsa_pubkey <- openssl::write_ssh(openssl::dsa_keygen()$pubkey)

## filter keys by type
pubkey <- pubkey_filter(c(rsa_pubkey, dsa_pubkey), "rsa")
identical(pubkey, rsa_pubkey)
#> [1] TRUE
```
