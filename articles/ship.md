# Make a secure shipment

## Introduction

This documents describes how to make secure shipments with the R package
*sship*. While *sship* provides technical means of very strong
protections through encryption of digital content all still depends on
proper and knowledgeable use. Therefore, please take a moment and study
the next paragraph very carefully.

*sship* ***makes sure that a secret will only be available to the
recipient by applying the recipient’s public key. When*** *sship* ***is
to be used for sending a secret to a recipient one must be absolutely
sure that the public key used by*** *sship* ***belongs to the intended
recipient. The authenticity of the public key should be established by a
combination of technical and social means. Technically, the public key
should be managed (by its owner, the recipient) through a key provider
that enforces multi-factor authentication of its users. Socially, the
two parties to share a secret should know of each other (personally,
professionally or similar) and establish trust both between themselves
and the technology to be used to ensure authenticity of the public
key.***

Following is an example of how the authenticity of a public key may be
sufficiently established. Person or entity X needs to send a secret data
file to person or entity Y and therefor need Y’s public key. A public
key provider exists (*e.g.* GitHub) and at this provider X has made a
dedicated group (or organization in GitHub-terms) that enforces
multi-factor authentication of its members. X asks Y to apply for a
membership of this group at the public key provider. X now expects a
member request from Y and grants it as it arrives. Since multi-factor
authentication is enforced it is unlikely that anyone else but Y may
add, alter or delete Y’s public key at the provider. X can thereafter
collect Y’s public key from the provider at any time and be sufficiently
sure that it will be authentic.

## How to

Basically, *sship* can be used for three things: encrypt files, send
encrypted files and decrypt files. The latter is described in the
article [Extract cargo from a secure
shipment](https://rapporteket.github.io/sship/articles/extract.html).
Encryption and sending (shipment) of files will be the subjects for the
remaining part of this article.

### Encrypt (secure) a file and send (ship) it

Both encryption and shipment can be obtained in one operation with the R
function [`sship()`](../reference/ship.md):

``` r
sship(content, recipient, pubkey_holder, vessel, declaration)
```

where `content` is the path to the file to be encrypted, `recipient` is
the unique user id of the recipient at the public key provider,
`pubkey_holder` is a reference to a known public key provider (see
[Configure *sship*](#conf) below), `vessel` is a reference to the
transportation method (see also [Configure *sship*](#conf) below) and
`declaration` is an optional “freight paper rubber stamp” to be
associated with the shipment. A practical example may look something
like this:

``` r
sship("secret_data.csv", "myfriend", "github", "ftp", "pickable")
```

which will collect *myfriend*’s public key from *github* and use it in
the encryption process of *secret_data.csv* before shipping it with
*ftp*. Immediately after an empty file named *pickable* is shipped using
the same route. *myfriend* can now check if the shipment has arrived by
polling for a file named *pickable* and collect the shipment before
starting the [process of unwrapping and
decryption](https://rapporteket.github.io/sship/articles/extract.html).

### Configure *sship*

Some of the above arguments to [`sship()`](../reference/ship.md) are
just references to the actual values that are stored in a configuration
file. *sship* comes with a default configuration but most likely this
will not be sufficient. A local config can be made by calling the
[`create_config()`](../reference/config.md) R function found in *sship*
(output also shown):

``` r
create_config()
[1] "./_sship.yml file created: fill it in"
```

In the above example of the R function [`sship()`](../reference/ship.md)
the references *github* and *ftp* depends on configuration for the
function to obtain proper values. The reference *github* already has a
working setup in the default configuration, but *ftp* has not. To
accomplish this open the file *\_sship.yml*, find the appropriate
section and edit accordingly:

``` yaml
...
recipient:
  bob:
    ftp:
      host: ftp.here.no
      port: 21
      path: path/to/myfriend
      user: myfriend
      pass: myfriendspassword
...
```

A recipients may require multiple ways of transportation and the
configuration allows for this by making additional entries for each
method of transportation.

#### Server mode

*ship* can also be applied as a tool in a centralized or server-like
environment where requirements for management and configuration may
differ from a local instance running R. Every time *sship* needs
information from configuration setting it looks for it in several
places. For a server setup the place to look for *sship*’s configuration
can be provided by setting the environmental variable
*R_SSHIP_CONFIG_PATH* to the directory where the configuration is to be
found. Making *R_SSHIP_CONFIG_PATH* accessible in an R session, *sship*
will abide by its value. However, if a local file named `_sship.yml`
exists in the current working directory it it will take precedence over
the one defined by *R_SSHIP_CONFIG_PATH*.
