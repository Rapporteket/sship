# Secure cargo and make shipment (secure shipment)

First, the content (a file) is encrypted and packed and then shipped to
the recipient using the specified vessel (transportation method). If the
given vessel is not available the function return an error. Optionally,
a declaration can also be associated with the shipment and dispatched
immediately after the actual cargo.

## Usage

``` r
sship(content, recipient, pubkey_holder, vessel, declaration = "")

dispatch(recipient, vessel, cargo)

dispatchable(recipient, vessel)

make_url(recipient, vessel)

make_opts(recipient, vessel)
```

## Arguments

- content:

  Character string: the full path to the file to be shipped

- recipient:

  Character string: user name uniquely defining the recipient both in
  terms of the public key used for securing the content and any identity
  control upon docking. See also *Details*.

- pubkey_holder:

  Character string: the holder of the (recipient's) public key.
  Currently, the only viable option here is 'github'.

- vessel:

  Character string: means of transportation. Currently one of 'ssh' or
  'ftp'.

- declaration:

  Character string: the name of an empty file to be associated with
  shipment of the cargo itself and dispatched immediately after. The
  most likely use case is for the recipient to check for this file being
  present before picking up the cargo itself. Default value is `""` in
  which case no declaration will be used.

- cargo:

  Character vector: all items associated with the current shipment. Used
  only internally.

## Value

TRUE if successful

## Details

Most likely access control will be enforced before docking of the
shipment can commence. For each recipient a list of available vessels
(transport methods) is defined and must include relevant credentials.
Functions used here rely on local configuration (`sship.yml`) to access
such credentials.

## See also

[enc](enc.md)
