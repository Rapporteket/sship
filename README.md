
# sship <img src="man/figures/logo.svg" align="right" height="150" />

<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/Rapporteket/sship?sort=semver)](https://github.com/Rapporteket/sship/releases)
[![Travis build status](https://travis-ci.org/Rapporteket/sship.svg?branch=master)](https://travis-ci.org/Rapporteket/sship)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/Rapporteket/sship?branch=master&svg=true)](https://ci.appveyor.com/project/Rapporteket/sship)
[![Codecov test coverage](https://codecov.io/gh/rapporteket/sship/branch/master/graph/badge.svg)](https://codecov.io/gh/rapporteket/sship?branch=master)
[![GitHub open issues](https://img.shields.io/github/issues/rapporteket/sship.svg)](https://github.com/rapporteket/sship/issues)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Doc](https://img.shields.io/badge/Doc--grey.svg)](https://rapporteket.github.io/sship/)
<!-- badges: end -->

This package provide tools for secure shipment. By strong protection of content itself safe passage can be provided even through hostile environments. Based on asymmetric cryptography no management of secrets is needed to make a shipment as long as authentic public keys are available. An overview of _sship_ can be found in the article [An overwiev of sship](https://rapporteket.github.io/sship/articles/overview.html).

## Install

You can install the latest version of sship from [GitHub](https://github.com) with:

``` r
remotes::install_github("Rapporteket/sship")
```

## Use
The main purpose of _sship_ is to enable sending a file securely to a recipient. This is done by first encrypting the file, wrap it up toghether with necessary documents before sending it off. Means of transportation may vary but could for instance be by plain file transfer or as an e-mail attachment. As a convenience to the recipient _sship_ also contains tools for unwrapping and decryption.

### Make a secure shipment
A shipment is secured by applying the recipient's public key. When content, recipient, provider of the recipient's public key, method of transportation (vessel) and optionally an accompanying shipment declaration are all known the _sship_ function can be applied to encrypt, wrap up and dispatch a shipment, all in one go:
```
sship(content, recipient, pubkey_holder, vessel, declaration)
```
For the time being, the only valid provider of public keys is GitHub and the recipeint must have a corresponding user account that contains a valid RSA public key. Further, the value of _reciepient_ will also be used to get local configuration that may be needed for the shipemnt to be made. Please refere to the the article [Make a secure shipment](https://rapporteket.github.io/sship/articles/ship.html) and the _sship_ function documentation for further details.

### Extract cargo from a secure shipment
Unwrapping and decryption can be made using the function ```dec()``` in this package by providing the path to the received tar-file and the recipient's private key. It is also possible to specify where the content is to be stored after it is unwrapped and decrypted (if not specified, content will be stored in the working directory):
```
dec(tarfile, keyfile, target_dir)
```
For further details including a description of how the content of a secure shipment can be extracted without R please see the article [Extract cargo from a secure shipment](https://rapporteket.github.io/sship/articles/extract.html).
