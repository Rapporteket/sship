% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enc.R
\name{enc}
\alias{enc}
\alias{enc_filename}
\alias{random_key}
\alias{make_pubkey_url}
\alias{get_pubkey}
\alias{enc_file}
\title{Encryption of shipment content}
\usage{
enc_filename(filename)

make_pubkey_url(pubkey_holder = "github", pid)

get_pubkey(pubkey_holder, pid)

enc(filename, pubkey_holder, pid)
}
\arguments{
\item{filename}{string with fully qualified path to a file}

\item{pubkey_holder}{string defining the provider of the public key used for
encryption of the symmetric key. Currently, 'github' is the only valid
option.}

\item{pid}{string uniquely defining the user at 'pubkey_holder' who is also
the owner of the  public key}
}
\value{
Character string providing a filename or a key
}
\description{
Various functions and helper functions to establish encrypted files. To
secure the content (any file) the Advanced Encryption Standard (AES) is
applied with an ephemeral key consisting of 256 random bits. This key is
only used once for encryption (and then one more time during decryption at a
later stage). A random 128 bit initialization vector (iv) is also applied
during encryption. There is no extra security gain in this since the key
will never be re-used for encryption/decryption. So, just for good measures
then :-) After the content has been encrypted the key itself is encrypted by
applying a public key offered by the recipient. This key is obtained from a
public provider. Currently, GitHub is the only option. The three files:
encrypted content, the encrypted key and the (cleartext) iv is then bundled
into a tarball ready for shipment.
}
\details{
Encrypted files can be decrypted outside R using the OpenSSL library. Both
the key and the initialization vector (iv) are binary and this method uses
the key directly (and not a [hashed] passphrase). OpenSSL decryption need to
be fed the key (and iv) as a string of hex digits. Methods for conversion
from binary to hex may vary between systems. Below, a bash shell (unix)
example is given
\preformatted{}
Step 1: decrypt symmetric key (open envelope) using a private key
\preformatted{
openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in key.enc -out key
}
Step 2: decrypt content by key obtained in step 1, also converting key and
iv to strings of hexadecimal digits
\preformatted{
openssl aes-256-cbc -d -in data.csv.enc -out data.csv \
-K $(hexdump -e '32/1 "\%02x"' key) -iv $(hexdump -e '16/1 "\%02x"' iv)
}
}
\seealso{
\link{dec}
}
